/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2022 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDifsBoxIteration  fragmentarium code, mdifs by knighty (jan 2012)

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_box.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSChessboardIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 zc = z;

	REAL4 col = zc + fractal->transformCommon.offset000;
	REAL4 repeats = fractal->transformCommon.scale3D444;
	repeats.x = floor(repeats.x * col.x);
	repeats.y = floor(repeats.y * col.y);
	repeats.z = floor(repeats.z * col.z);
	REAL auxCol;
	if (!fractal->transformCommon.functionEnabledCFalse)
	{
		auxCol = repeats.x + repeats.y;
	}
	else
	{
		auxCol = repeats.x + repeats.y + repeats.z;
	}
	auxCol = (auxCol * 0.5f - floor(auxCol * 0.5f)) * 2.0f;

	REAL rDE;
	if (!fractal->transformCommon.functionEnabledFalse)
	{
		zc = fabs(zc) - fractal->transformCommon.offset110; // size
		rDE = max(zc.x, max(zc.y, zc.z));
	}
	else
		rDE = zc.z;

	if (fractal->transformCommon.functionEnabledZcFalse
			&& aux->i >= fractal->transformCommon.startIterationsZc
			&& aux->i < fractal->transformCommon.stopIterationsZc)
		z = zc;

	if (!fractal->analyticDE.enabledFalse)
		aux->dist = min(aux->dist, rDE);
	else
		aux->dist = rDE;

	aux->color = auxCol;

	return z;
}
