/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * DIFSGridV2Iteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and Buddhi

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the function "TransfDIFSGridV2Iteration" in the file fractal_formulas.cpp
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSGridV2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 zc = z;

	REAL size = fractal->transformCommon.scale1;
	REAL grid = 0.0f;

	zc.z /= fractal->transformCommon.scaleF1;

	if (fractal->transformCommon.functionEnabledMFalse
			&& aux->i >= fractal->transformCommon.startIterationsM
			&& aux->i < fractal->transformCommon.stopIterationsM)
	{
		REAL temp = zc.x;
		zc.x = mad(fractal->transformCommon.scaleA0, native_sin(zc.y), zc.x);
		zc.y = mad(fractal->transformCommon.scaleB0, native_sin(temp), zc.y);
	}

	if (fractal->transformCommon.functionEnabledNFalse
			&& aux->i >= fractal->transformCommon.startIterationsN
			&& aux->i < fractal->transformCommon.stopIterationsN)
	{
		REAL k = fractal->transformCommon.angle0;

		if (fractal->transformCommon.functionEnabledAxFalse)
			k *= aux->i + fractal->transformCommon.offset1;

		REAL swap;
		if (!fractal->transformCommon.functionEnabledOFalse)
			swap = zc.x;
		else
			swap = zc.z;

		if (fractal->transformCommon.functionEnabledAzFalse) swap = fabs(swap);
		REAL c = native_cos(k * zc.y);
		REAL s = native_sin(k * zc.y);
		if (!fractal->transformCommon.functionEnabledOFalse)
		{
			zc.x = mad(c, swap, -s * zc.y);
		}
		else
		{
			zc.z = mad(c, swap, -s * zc.y);
		}
		zc.y = mad(s, swap, c * zc.y);
	}

	if (fractal->transformCommon.rotationEnabled)
	{
		zc = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, zc);
	}

	REAL xFloor = fabs(zc.x - size * floor(native_divide(zc.x, size) + 0.5f));
	REAL yFloor = fabs(zc.y - size * floor(native_divide(zc.y, size) + 0.5f));
	REAL gridXY = min(xFloor, yFloor);

	if (!fractal->transformCommon.functionEnabledJFalse)
		grid = native_sqrt(mad(gridXY, gridXY, zc.z * zc.z));
	else
		grid = max(fabs(gridXY), fabs(zc.z));

	aux->dist =
		min(aux->dist, native_divide((grid - fractal->transformCommon.offset0005), (aux->DE + 1.0f)));
	return z;
}