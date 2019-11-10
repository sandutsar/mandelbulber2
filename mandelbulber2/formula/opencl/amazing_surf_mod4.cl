/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * amazing surf Mod4 based on Mandelbulber3D. Formula proposed by Kali, with features added by
 * DarkBeam
 *
 * This formula has a c.x c.y SWAP
 *
 * @reference
 * http://www.fractalforums.com/mandelbulb-3d/custom-formulas-and-transforms-release-t17106/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the function "AmazingSurfMod4Iteration" in the file fractal_formulas.cpp
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 AmazingSurfMod4Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 c = aux->const_c;
	z.x = fabs(z.x + fractal->transformCommon.additionConstant111.x)
				- fabs(z.x - fractal->transformCommon.additionConstant111.x) - z.x;
	z.y = fabs(z.y + fractal->transformCommon.additionConstant111.y)
				- fabs(z.y - fractal->transformCommon.additionConstant111.y) - z.y;
	// no z fold
	z += fractal->transformCommon.offsetA000;
	REAL rr = dot(z, z);
	REAL MinRR = fractal->transformCommon.minR2p25;
	REAL dividend = rr < MinRR ? MinRR : min(rr, 1.0f);

	// scale
	REAL useScale = 1.0f;
	{
		useScale = native_divide((aux->actualScaleA + fractal->transformCommon.scale2), dividend);
		z *= useScale;
		aux->DE = mad(aux->DE, fabs(useScale), 1.0f);

		if (fractal->transformCommon.functionEnabledKFalse)
		{
			// update actualScaleA for next iteration
			REAL vary = fractal->transformCommon.scaleVary0
									* (fabs(aux->actualScaleA) - fractal->transformCommon.scaleC1);
			aux->actualScaleA -= vary;
		}
	}

	if (fractal->transformCommon.rotation2EnabledFalse)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	if (fractal->transformCommon.addCpixelEnabledFalse)
		z += (REAL4){c.y, c.x, c.z, c.w} * fractal->transformCommon.constantMultiplier111;
	z += fractal->transformCommon.offset000;

	z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix2, z);
	return z;
}