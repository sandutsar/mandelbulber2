/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *


 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_sin_tan.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfSinYM3dIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (fractal->transformCommon.functionEnabledAx)
		z.x = native_sin((z.x - fractal->transformCommon.offset000.x)
												 * fractal->transformCommon.constantMultiplierA111.x)
						* fractal->transformCommon.constantMultiplierB111.x
					+ fractal->transformCommon.offsetA000.x;
	if (fractal->transformCommon.functionEnabledAyFalse)
		z.y = native_sin((z.y - fractal->transformCommon.offset000.y)
												 * fractal->transformCommon.constantMultiplierA111.y)
						* fractal->transformCommon.constantMultiplierB111.y
					+ fractal->transformCommon.offsetA000.y;
	if (fractal->transformCommon.functionEnabledAzFalse)
		z.z = native_sin((z.z - fractal->transformCommon.offset000.z)
												 * fractal->transformCommon.constantMultiplierA111.z)
						* fractal->transformCommon.constantMultiplierB111.z
					+ fractal->transformCommon.offsetA000.z;

	// DE tweak
	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	return z;
}
