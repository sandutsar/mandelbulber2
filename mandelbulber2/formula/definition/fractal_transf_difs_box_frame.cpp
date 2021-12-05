/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.         ______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,      / ____/ __    __
 *                                        \><||i|=>>%)     / /   __/ /___/ /_
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    / /__ /_  __/_  __/
 * The project is licensed under GPLv3,   -<>>=|><|||`    \____/ /_/   /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDIFSBosFrameIteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
 */

#include "all_fractal_definitions.h"

cFractalTransfDIFSBoxFrame::cFractalTransfDIFSBoxFrame() : cAbstractFractal()
{
	nameInComboBox = "T>DIFS Box Frame";
	internalName = "transf_difs_box_frame";
	internalID = fractal::transfDIFSBoxFrame;
	DEType = analyticDEType;
	DEFunctionType = customDEFunction;
	cpixelAddition = cpixelDisabledByDefault;
	defaultBailout = 100.0;
	DEAnalyticFunction = analyticFunctionCustomDE;
	coloringFunction = coloringFunctionDefault;
}

void cFractalTransfDIFSBoxFrame::FormulaCode(
	CVector4 &z, const sFractal *fractal, sExtendedAux &aux)
{
	// tranform z
	if (fractal->transformCommon.functionEnabledCxFalse
			&& aux.i >= fractal->transformCommon.startIterationsA
			&& aux.i < fractal->transformCommon.stopIterationsA)
	{
		z.y = fabs(z.y);
		double psi = M_PI / fractal->transformCommon.int8X;
		psi = fabs(fmod(atan2(z.y, z.x) + psi, 2.0 * psi) - psi);
		double len = sqrt(z.x * z.x + z.y * z.y);
		z.x = cos(psi) * len;
		z.y = sin(psi) * len;
	}

	if (fractal->transformCommon.functionEnabledCyFalse
			&& aux.i >= fractal->transformCommon.startIterationsB
			&& aux.i < fractal->transformCommon.stopIterationsB)
	{
		z.z = fabs(z.z);
		double psi = M_PI / fractal->transformCommon.int8Y;
		psi = fabs(fmod(atan2(z.z, z.y) + psi, 2.0 * psi) - psi);
		double len = sqrt(z.y * z.y + z.z * z.z);
		z.y = cos(psi) * len;
		z.z = sin(psi) * len;
	}

	if (fractal->transformCommon.functionEnabledCzFalse
			&& aux.i >= fractal->transformCommon.startIterationsC
			&& aux.i < fractal->transformCommon.stopIterationsC)
	{
		z.x = fabs(z.x);
		double psi = M_PI / fractal->transformCommon.int8Z;
		psi = fabs(fmod(atan2(z.x, z.z) + psi, 2.0 * psi) - psi);
		double len = sqrt(z.z * z.z + z.x * z.x);
		z.z = cos(psi) * len;
		z.x = sin(psi) * len;
	}




	z = fabs(z - fractal->transformCommon.offset000);


	z = fractal->transformCommon.rotationMatrix.RotateVector(z);




	CVector4 zc = z;
	zc = fractal->transformCommon.rotationMatrix2.RotateVector(zc);
	zc = fabs(zc) - fractal->transformCommon.offsetC111;
	CVector4 q = CVector4(fractal->transformCommon.offsetp01,
						fractal->transformCommon.offsetAp01,
						fractal->transformCommon.offsetBp01, 0.0);
	q = fabs(zc) - q;

	double lenX = min(max(zc.x, max(q.y, q.z)), 0.0);
	double lenY = min(max(q.x, max(zc.y, q.z)), 0.0);
	double lenZ = min(max(q.x, max(q.y, zc.z)), 0.0);

	CVector4 mz = zc;
	mz.x = max(zc.x, 0.0);
	mz.y = max(zc.y, 0.0);
	mz.z = max(zc.z, 0.0);

	CVector4 mq = q;
	mq.x = max(q.x, 0.0);
	mq.y = max(q.y, 0.0);
	mq.z = max(q.z, 0.0);

	lenX += (CVector3(mz.x, mq.y, mq.z)).Length();
	lenY += (CVector3(mq.x, mz.y, mq.z)).Length();
	lenZ += (CVector3(mq.x, mq.y, mz.z)).Length();

	double D = min(min(lenX, lenY), lenZ);

	aux.dist = min(aux.dist, D);

	if (fractal->transformCommon.functionEnabledZcFalse
			&& aux.i >= fractal->transformCommon.startIterationsZc
			&& aux.i < fractal->transformCommon.stopIterationsZc)
				z = zc;

}