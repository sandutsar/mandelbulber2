/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * DifsPrismIteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_difs_prism.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 DIFSPrismIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL colorAdd = 0.0f;
	REAL4 oldZ = z;
	REAL4 boxFold = fractal->transformCommon.additionConstantA111;

	// abs z
	if (fractal->transformCommon.functionEnabledAx
			&& aux->i >= fractal->transformCommon.startIterationsX
			&& aux->i < fractal->transformCommon.stopIterationsX)
		z.x = fabs(z.x);
	if (fractal->transformCommon.functionEnabledAy
			&& aux->i >= fractal->transformCommon.startIterationsY
			&& aux->i < fractal->transformCommon.stopIterationsY)
		z.y = fabs(z.y);
	if (fractal->transformCommon.functionEnabledAzFalse
			&& aux->i >= fractal->transformCommon.startIterationsZ
			&& aux->i < fractal->transformCommon.stopIterationsZ)
		z.z = fabs(z.z);
	// folds
	if (fractal->transformCommon.functionEnabledFalse)
	{
		// xy box fold
		if (fractal->transformCommon.functionEnabledAFalse
				&& aux->i >= fractal->transformCommon.startIterationsA
				&& aux->i < fractal->transformCommon.stopIterationsA)
		{
			z.x -= boxFold.x;
			z.y -= boxFold.y;
		}
		// xyz box fold
		if (fractal->transformCommon.functionEnabledBFalse
				&& aux->i >= fractal->transformCommon.startIterationsB
				&& aux->i < fractal->transformCommon.stopIterationsB)
			z -= boxFold;
		// polyfold
		if (fractal->transformCommon.functionEnabledPFalse
				&& aux->i >= fractal->transformCommon.startIterationsP
				&& aux->i < fractal->transformCommon.stopIterationsP)
		{
			z.x = fabs(z.x);
			REAL psi = M_PI_F / fractal->transformCommon.int6;
			psi = fabs(fmod(atan(z.y / z.x) + psi, 2.0f * psi) - psi);
			REAL len = native_sqrt(z.x * z.x + z.y * z.y);
			z.x = native_cos(psi) * len;
			z.y = native_sin(psi) * len;
		}
		// diag fold1
		if (fractal->transformCommon.functionEnabledCxFalse
				&& aux->i >= fractal->transformCommon.startIterationsCx
				&& aux->i < fractal->transformCommon.stopIterationsCx)
			if (z.x > z.y)
			{
				REAL temp = z.x;
				z.x = z.y;
				z.y = temp;
			}
		// abs offsets
		if (fractal->transformCommon.functionEnabledCFalse
				&& aux->i >= fractal->transformCommon.startIterationsC
				&& aux->i < fractal->transformCommon.stopIterationsC)
		{
			REAL xOffset = fractal->transformCommon.offsetC0;
			if (z.x < xOffset) z.x = fabs(z.x - xOffset) + xOffset;
		}
		if (fractal->transformCommon.functionEnabledDFalse
				&& aux->i >= fractal->transformCommon.startIterationsD
				&& aux->i < fractal->transformCommon.stopIterationsD)
		{
			REAL yOffset = fractal->transformCommon.offsetD0;
			if (z.y < yOffset) z.y = fabs(z.y - yOffset) + yOffset;
		}
		// diag fold2
		if (fractal->transformCommon.functionEnabledCyFalse
				&& aux->i >= fractal->transformCommon.startIterationsCy
				&& aux->i < fractal->transformCommon.stopIterationsCy)
			if (z.x > z.y)
			{
				REAL temp = z.x;
				z.x = z.y;
				z.y = temp;
			}
	}

	// reverse offset part 1
	if (aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
		z.x -= fractal->transformCommon.offsetE2;

	if (aux->i >= fractal->transformCommon.startIterationsF
			&& aux->i < fractal->transformCommon.stopIterationsF)
		z.y -= fractal->transformCommon.offsetF2;

	// scale
	REAL useScale = 1.0f;
	if (aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		useScale = aux->actualScaleA + fractal->transformCommon.scale2;
		z *= useScale;
		aux->DE = aux->DE * fabs(useScale) + 1.0f;
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

	// reverse offset part 2
	if (aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
		z.x += fractal->transformCommon.offsetE2;

	if (aux->i >= fractal->transformCommon.startIterationsF
			&& aux->i < fractal->transformCommon.stopIterationsF)
		z.y += fractal->transformCommon.offsetF2;

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
	REAL4 zc = oldZ;

	if (aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations)
	{
		REAL tp;
		REAL len = fractal->transformCommon.offset1;
		REAL face = fractal->transformCommon.offset05;

		// swap axis
		if (fractal->transformCommon.functionEnabledSwFalse)
		{
			REAL temp = zc.x;
			zc.x = zc.z;
			zc.z = temp;
		}

		REAL4 absZ = fabs(zc);

		if (fractal->transformCommon.functionEnabledMFalse
				&& aux->i >= fractal->transformCommon.startIterationsM
				&& aux->i < fractal->transformCommon.stopIterationsM)
		{
			tp = absZ.z;
			if (fractal->transformCommon.functionEnabledBxFalse) tp *= tp;

			zc.y += tp * fractal->transformCommon.scale0;
		}

		if (fractal->transformCommon.functionEnabledNFalse
				&& aux->i >= fractal->transformCommon.startIterationsN
				&& aux->i < fractal->transformCommon.stopIterationsN)
		{
			tp = absZ.z;
			if (fractal->transformCommon.functionEnabledByFalse) tp *= tp;
			len += tp * fractal->transformCommon.scaleA0;
		}

		if (fractal->transformCommon.functionEnabledOFalse
				&& aux->i >= fractal->transformCommon.startIterationsO
				&& aux->i < fractal->transformCommon.stopIterationsO)
		{
			tp = absZ.z;
			if (fractal->transformCommon.functionEnabledBzFalse) tp *= tp;
			face += tp * fractal->transformCommon.scaleB0;
		}

		REAL priD = max(fabs(zc.x) - len, max(fabs(zc.y) * SQRT_3_4_F + zc.z * 0.5f, -zc.z) - face);

		aux->dist = min(aux->dist, priD / aux->DE);
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