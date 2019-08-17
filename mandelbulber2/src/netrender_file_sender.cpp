/**
 * Mandelbulber v2, a 3D fractal generator       ,=#MKNmMMKmmßMNWy,
 *                                             ,B" ]L,,p%%%,,,§;, "K
 * Copyright (C) 2019 Mandelbulber Team        §R-==%w["'~5]m%=L.=~5N
 *                                        ,=mm=§M ]=4 yJKA"/-Nsaj  "Bw,==,,
 * This file is part of Mandelbulber.    §R.r= jw",M  Km .mM  FW ",§=ß., ,TN
 *                                     ,4R =%["w[N=7]J '"5=],""]]M,w,-; T=]M
 * Mandelbulber is free software:     §R.ß~-Q/M=,=5"v"]=Qf,'§"M= =,M.§ Rz]M"Kw
 * you can redistribute it and/or     §w "xDY.J ' -"m=====WeC=\ ""%""y=%"]"" §
 * modify it under the terms of the    "§M=M =D=4"N #"%==A%p M§ M6  R' #"=~.4M
 * GNU General Public License as        §W =, ][T"]C  §  § '§ e===~ U  !§[Z ]N
 * published by the                    4M",,Jm=,"=e~  §  §  j]]""N  BmM"py=ßM
 * Free Software Foundation,          ]§ T,M=& 'YmMMpM9MMM%=w=,,=MT]M m§;'§,
 * either version 3 of the License,    TWw [.j"5=~N[=§%=%W,T ]R,"=="Y[LFT ]N
 * or (at your option)                   TW=,-#"%=;[  =Q:["V""  ],,M.m == ]N
 * any later version.                      J§"mr"] ,=,," =="""J]= M"M"]==ß"
 *                                          §= "=C=4 §"eM "=B:m|4"]#F,§~
 * Mandelbulber is distributed in            "9w=,,]w em%wJ '"~" ,=,,ß"
 * the hope that it will be useful,                 . "K=  ,=RMMMßM"""
 * but WITHOUT ANY WARRANTY;                            .'''
 * without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Mandelbulber. If not, see <http://www.gnu.org/licenses/>.
 *
 * ###########################################################################
 *
 * Authors: Sebastian Jennen (jenzebas@gmail.com)
 *
 * NetrenderFileSender class - watches for transmissable files on the client to
 * send to the server
 */

#include "netrender_file_sender.hpp"

NetrenderFileSender::NetrenderFileSender(QObject *parent) : QObject(parent)
{
	actualFileSize = 0;
	actualChunkIndex = 0;
	actualNumberOfChunks = 0;
	sendingInProgress = false;
	lastChunk = false;
}

NetrenderFileSender::~NetrenderFileSender() = default;

void NetrenderFileSender::AddFileToQueue(const QString &filename)
{
	fileQueue.enqueue(filename);

	if (!sendingInProgress)
	{
		QString filenameToSend = fileQueue.dequeue();
		sendFileOverNetrender(filenameToSend);
	}
}

void NetrenderFileSender::AcknowledgeReceived()
{
	if (sendingInProgress)
	{
		if (lastChunk)
		{
			// if file finished and there is more to send...
			if (fileQueue.size() > 0)
			{
				//...then send next file
				QString filenameToSend = fileQueue.dequeue();
				sendFileOverNetrender(filenameToSend);
			}
			else
			{
				// else wait for new file in queue
				sendingInProgress = false;
			}
		}
		else
		{
			SendDataChunk();
		}
	}
}

void NetrenderFileSender::sendFileOverNetrender(const QString &fileName)
{
	int fileSize = QFile(fileName).size();

	if (fileSize > 0)
	{
		actualFile.setFileName(fileName);

		if (actualFile.open(QIODevice::ReadOnly))
		{
			actualFileName = fileName;
			actualFileSize = fileSize;
			actualNumberOfChunks = ceil(fileSize / NetrenderFileSender::CHUNK_SIZE);
			actualChunkIndex = 0;
			sendingInProgress = true;
			lastChunk = false;

			emit NetRenderSendHeader(fileSize, fileName);
		}
		else
		{
			qCritical("Cannot open file to send via NetRender") << fileName;
		}
	}
}

void NetrenderFileSender::SendDataChunk()
{
	if (actualFile.isOpen())
	{
		qint64 bytesLeft = actualFileSize - actualChunkIndex * CHUNK_SIZE;
		qint64 bytesToRead = max(CHUNK_SIZE, bytesLeft);
		QByteArray data = actualFile.read(bytesToRead);
		actualChunkIndex++;
		emit NetRenderSendChunk(actualChunkIndex, data);

		if (bytesLeft == bytesToRead) lastChunk = true;
	}
}
