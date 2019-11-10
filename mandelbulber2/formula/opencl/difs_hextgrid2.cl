/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * DIFSHextgrid2Iteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and  darkbeams optimized verion @reference
 * http://www.fractalforums.com/mandelbulb-3d/custom-formulas-and-transforms-release-t17106/
 * "Beautiful iso-surface made of a hexagonal grid of tubes.
 * Taken from K3DSurf forum, posted by user abdelhamid belaid."

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the function "DIFSHextgrid2Iteration" in the file fractal_formulas.cpp
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 DIFSHextgrid2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL colorAdd = 0.0f;

	// sphere inversion
	if (fractal->transformCommon.sphereInversionEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsX
			&& aux->i < fractal->transformCommon.stopIterations1)
	{
		z += fractal->transformCommon.offset000;
		REAL rr = dot(z, z);
		z *= native_divide(fractal->transformCommon.scaleG1, rr);
		aux->DE *= (native_divide(fractal->transformCommon.scaleG1, rr));
		z += fractal->transformCommon.additionConstant000 - fractal->transformCommon.offset000;
		z *= fractal->transformCommon.scaleA1;
		aux->DE *= fractal->transformCommon.scaleA1;
	}

	if (fractal->transformCommon.functionEnabledCFalse
			&& aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC1)
	{
		REAL Tp = fractal->transformCommon.offset2;
		z.x = fmod(fabs(z.x) + Tp, 2.0f * Tp) - Tp;
		Tp = fractal->transformCommon.offsetA2;
		z.y = fmod(fabs(z.y) + Tp, 2.0f * Tp) - Tp;
	}

	// scale
	if (aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		REAL useScale = aux->actualScaleA + fractal->transformCommon.scale2;
		z *= useScale;
		aux->DE = aux->DE * fabs(useScale);
		// scale vary
		if (fractal->transformCommon.functionEnabledKFalse
				&& aux->i >= fractal->transformCommon.startIterationsK
				&& aux->i < fractal->transformCommon.stopIterationsK)
		{
			// update actualScaleA for next iteration
			REAL vary = fractal->transformCommon.scaleVary0
									* (fabs(aux->actualScaleA) - fractal->transformCommon.scaleC1);
			aux->actualScaleA -= vary;
		}
	}

	// offset
	z += fractal->transformCommon.offset001;

	// rotation
	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	// DE
	REAL colorDist = aux->dist;
	REAL4 zc = z;

	// Hextgrid2
	if (aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations)
	{
		REAL size = fractal->transformCommon.scale1;
		REAL hexD = 0.0f;
		zc.z /= fractal->transformCommon.scaleF1;

		REAL cosPi6 = native_cos(native_divide(M_PI_F, 6.0f));
		REAL yFloor = fabs(zc.y - size * floor(native_divide(zc.y, size) + 0.5f));
		REAL xFloor = fabs(zc.x
											 - size * native_divide(1.5f, cosPi6)
													 * floor(native_divide(native_divide(zc.x, size), 1.5f) * cosPi6 + 0.5f));
		REAL gridMax = max(yFloor, xFloor * cosPi6 + yFloor * native_sin(native_divide(M_PI_F, 6.0f)));
		REAL gridMin = min(gridMax - size * 0.5f, yFloor);
		if (!fractal->transformCommon.functionEnabledJFalse)
			hexD = native_sqrt(mad(gridMin, gridMin, zc.z * zc.z));
		else
			hexD = max(fabs(gridMin), fabs(zc.z));
		hexD -= fractal->transformCommon.offset0005;

		aux->dist = min(aux->dist, native_divide(hexD, (aux->DE + 1.0f)));
	}

	// aux->color
	if (fractal->foldColor.auxColorEnabled)
	{
		if (fractal->foldColor.auxColorEnabledFalse)
		{
			colorAdd += fractal->foldColor.difs0000.x * fabs(z.x * z.y);
			colorAdd += fractal->foldColor.difs0000.y * max(z.x, z.y);
		}
		colorAdd += fractal->foldColor.difs1;
		if (fractal->foldColor.auxColorEnabledA)
		{
			if (colorDist != aux->dist) aux->color += colorAdd;
		}
		else
			aux->color += colorAdd;
	}
	return z;
}