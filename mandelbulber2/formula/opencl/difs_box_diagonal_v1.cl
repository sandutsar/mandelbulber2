/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * DIFSBoxDiagonalV1Iteration  fragmentarium code, mdifs by knighty (jan 2012)
 *

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the function "DIFSBoxDiagonalV1Iteration" in the file fractal_formulas.cpp
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 DIFSBoxDiagonalV1Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL colorAdd = 0.0f;
	REAL4 boxFold = fractal->transformCommon.additionConstantA111;

	// diag 1
	if (aux->i >= fractal->transformCommon.startIterationsCx
			&& aux->i < fractal->transformCommon.stopIterationsCx)
		if (z.x > z.y)
		{
			REAL temp = z.x;
			z.x = z.y;
			z.y = temp;
		}

	// abs and boxfoldxy
	if (aux->i >= fractal->transformCommon.startIterationsX
			&& aux->i < fractal->transformCommon.stopIterationsX)
		z.x = fabs(z.x);
	if (aux->i >= fractal->transformCommon.startIterationsY
			&& aux->i < fractal->transformCommon.stopIterationsY)
		z.y = fabs(z.y);

	if (aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		z.x -= boxFold.x;
		z.y -= boxFold.y;
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

	// reverse offset part 1
	if (aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
		z.x -= fractal->transformCommon.offsetE0;

	if (aux->i >= fractal->transformCommon.startIterationsF
			&& aux->i < fractal->transformCommon.stopIterationsF)
		z.y -= fractal->transformCommon.offsetF0;

	// scale
	REAL useScale = 1.0f;
	if (aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		useScale = aux->actualScaleA + fractal->transformCommon.scale2;
		z *= useScale;
		aux->DE = mad(aux->DE, fabs(useScale), 1.0f);

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
		z.x += fractal->transformCommon.offsetE0;

	if (aux->i >= fractal->transformCommon.startIterationsF
			&& aux->i < fractal->transformCommon.stopIterationsF)
		z.y += fractal->transformCommon.offsetF0;

	// offset
	z += fractal->transformCommon.offset001;

	// rotation
	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}
	REAL colorDist = aux->dist;
	REAL4 zc = z;

	// box
	if (aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations)
	{
		REAL4 boxSize = fractal->transformCommon.additionConstant111;
		// curve
		if (fractal->transformCommon.functionEnabledTFalse
				&& aux->i >= fractal->transformCommon.startIterationsT
				&& aux->i < fractal->transformCommon.stopIterationsT)
		{
			REAL absZ = fabs(z.z);
			absZ *= absZ;
			boxSize.x += fractal->transformCommon.scale0 * absZ;
			boxSize.y += fractal->transformCommon.scale0 * absZ;
		}
		// pyramid
		if (fractal->transformCommon.functionEnabledMFalse
				&& aux->i >= fractal->transformCommon.startIterationsM
				&& aux->i < fractal->transformCommon.stopIterationsM)
		{
			boxSize.x -= fractal->transformCommon.scaleA0 * zc.z;
			boxSize.y -= fractal->transformCommon.scaleA0 * zc.z;
		}
		zc = fabs(zc) - boxSize;
		zc.x = max(zc.x, 0.0f);
		zc.y = max(zc.y, 0.0f);
		zc.z = max(zc.z, 0.0f);
		REAL zcd = length(zc);

		aux->dist = min(aux->dist, native_divide(zcd, aux->DE));
	}

	// aux->color
	if (fractal->foldColor.auxColorEnabled)
	{
		if (fractal->foldColor.auxColorEnabledFalse)
		{
			colorAdd += fractal->foldColor.difs0000.x * aux->dist;

			colorAdd += fractal->foldColor.difs0000.y * fabs(z.x * z.y);
			// colorAdd += fractal->foldColor.difs0000.z * round(abs(z.x * z.y));
			// colorAdd += fractal->foldColor.difs0000.w * max(z.x, z.y); //
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