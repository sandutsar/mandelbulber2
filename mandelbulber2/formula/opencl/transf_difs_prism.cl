/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDIFSPrismIteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the function "TransfDIFSPrismIteration" in the file fractal_formulas.cpp
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSPrismIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 zc = z;

	// swap axis
	if (fractal->transformCommon.functionEnabledSwFalse)
	{
		{
			REAL temp = zc.x;
			zc.x = zc.z;
			zc.z = temp;
		}
	}

	REAL priD = max(fabs(zc.x) - fractal->transformCommon.offset1,
		max(fabs(zc.y) * SQRT_3_4 + zc.z * 0.5f, -zc.z) - fractal->transformCommon.offset05);

	aux->dist = min(aux->dist, native_divide(priD, aux->DE));
	return z;
}