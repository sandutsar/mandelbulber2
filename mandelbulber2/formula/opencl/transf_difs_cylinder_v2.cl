/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDifsCylinderV2Iteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the function "TransfDIFSCylinderV2Iteration" in the file fractal_formulas.cpp
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSCylinderV2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	z += fractal->transformCommon.offset000;
	REAL4 zc = z;

	REAL temp;
	// swap axis
	if (fractal->transformCommon.functionEnabledSwFalse)
	{
		{
			REAL temp = zc.x;
			zc.x = zc.z;
			zc.z = temp;
		}
	}

	REAL cylR = zc.x * zc.x;
	REAL absH = fabs(zc.z);
	REAL lengthCyl = zc.z;

	cylR = native_sqrt(mad(zc.y, zc.y, cylR));
	REAL cylH = absH - fractal->transformCommon.offsetA1;

	// no absz
	if (fractal->transformCommon.functionEnabledMFalse
			&& aux->i >= fractal->transformCommon.startIterationsM
			&& aux->i < fractal->transformCommon.stopIterationsM)
	{
		absH = lengthCyl;
	}

	// abs sqrd
	if (fractal->transformCommon.functionEnabledTFalse
			&& aux->i >= fractal->transformCommon.startIterationsT
			&& aux->i < fractal->transformCommon.stopIterationsT)
	{
		absH *= absH;
	}

	REAL cylRm = cylR - fractal->transformCommon.radius1;
	cylRm += fractal->transformCommon.scale0 * absH;

	// tops
	if (fractal->transformCommon.functionEnabledNFalse
			&& aux->i >= fractal->transformCommon.startIterationsN
			&& aux->i < fractal->transformCommon.stopIterationsN)
	{
		temp = cylR;
	}
	else
	{
		temp = cylRm;
	}
	temp = max(temp, 0.0f);
	REAL cylHm = max(cylH, 0.0f);
	REAL cylD = native_sqrt(mad(temp, temp, cylHm * cylHm));

	// rings
	if (fractal->transformCommon.functionEnabledOFalse
			&& aux->i >= fractal->transformCommon.startIterationsO
			&& aux->i < fractal->transformCommon.stopIterationsO)
	{
		cylD = native_sqrt(mad(cylRm, cylRm, cylH * cylH));
	}
	cylD = min(max(cylRm, cylH) - fractal->transformCommon.offsetR0, 0.0f) + cylD;

	aux->dist = min(aux->dist, native_divide(cylD, aux->DE));
	return z;
}