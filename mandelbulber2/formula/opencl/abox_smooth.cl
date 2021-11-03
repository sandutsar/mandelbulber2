﻿/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * ABoxMod15,
 * The Mandelbox fractal known as AmazingBox or ABox, invented by Tom Lowe in 2010
 * Variations from DarkBeam, Buddhi and mclarekin
 * This formula has a c.x c.y SWAP
 * @reference
 * http://www.fractalforums.com/ifs-iterated-function-systems/amazing-fractal/msg12467/#msg12467

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_abox_mod15.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 AboxSmoothIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL t = 1.0f;
	// sphere inversion
	if (fractal->transformCommon.sphereInversionEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsI
			&& aux->i < fractal->transformCommon.stopIterations1)
	{
		z += fractal->transformCommon.offset000;
		REAL rr = dot(z, z);
		t = fractal->transformCommon.scaleG1 / rr;
		z *= t;
		aux->DE *= t;
		z += fractal->transformCommon.additionConstant000 - fractal->transformCommon.offset000;
		z *= fractal->transformCommon.scaleA1;
		aux->DE *= fractal->transformCommon.scaleA1;
	}

	REAL4 oldZ = z;
	if (fractal->transformCommon.functionEnabledAx
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		REAL sm = fractal->mandelbox.sharpness;

		REAL zk1 = SmoothConditionAGreaterB(z.x, fractal->transformCommon.offset111.x, sm);
		REAL zk2 = SmoothConditionALessB(z.x, -fractal->transformCommon.offset111.x, sm);
		z.x = z.x * (1.0 - zk1) + (2.0 * fractal->transformCommon.offset111.x - z.x) * zk1;
		z.x = z.x * (1.0 - zk2) + (-2.0 * fractal->transformCommon.offset111.x - z.x) * zk2;

		zk1 = SmoothConditionAGreaterB(z.y, fractal->transformCommon.offset111.y, sm);
		zk2 = SmoothConditionALessB(z.y, -fractal->transformCommon.offset111.y, sm);
		z.y = z.y * (1.0 - zk1) + (2.0 * fractal->transformCommon.offset111.y - z.y) * zk1;
		z.y = z.y * (1.0 - zk2) + (-2.0 * fractal->transformCommon.offset111.y - z.y) * zk2;

		if (fractal->transformCommon.functionEnabled)
		{
			zk1 = SmoothConditionAGreaterB(z.z, fractal->transformCommon.offset111.z, sm);
			zk2 = SmoothConditionALessB(z.z, -fractal->transformCommon.offset111.z, sm);
			z.z = z.z * (1.0 - zk1) + (2.0 * fractal->transformCommon.offset111.z - z.z) * zk1;
			z.z = z.z * (1.0 - zk2) + (-2.0 * fractal->transformCommon.offset111.z - z.z) * zk2;
		}
	}

	if (fractal->transformCommon.functionEnabledBFalse
			&& aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{
		z.x = fabs(z.x + fractal->transformCommon.offset111.x)
					- fabs(z.x - fractal->transformCommon.offset111.x) - z.x;
		z.y = fabs(z.y + fractal->transformCommon.offset111.y)
					- fabs(z.y - fractal->transformCommon.offset111.y) - z.y;
		if (fractal->transformCommon.functionEnabled)
			z.z = fabs(z.z + fractal->transformCommon.offset111.z)
						- fabs(z.z - fractal->transformCommon.offset111.z) - z.z;
	}

	if (fractal->transformCommon.functionEnabledDFalse
			&& aux->i >= fractal->transformCommon.startIterationsD
			&& aux->i < fractal->transformCommon.stopIterationsD1)
	{
		REAL4 limit = fractal->transformCommon.offset111;
		REAL4 length = 2.0f * limit;
		REAL4 tgladS = 1.0f / length;
		REAL4 Add = (REAL4){0.0f, 0.0f, 0.0f, 0.0f};
		if (fabs(z.x) < limit.x) Add.x = z.x * z.x * tgladS.x;
		if (fabs(z.y) < limit.y) Add.y = z.y * z.y * tgladS.y;
		if (fabs(z.z) < limit.z) Add.z = z.z * z.z * tgladS.z;
		if (fabs(z.x) > limit.x && fabs(z.x) < length.x)
			Add.x = (length.x - fabs(z.x)) * (length.x - fabs(z.x)) * tgladS.x;
		if (fabs(z.y) > limit.y && fabs(z.y) < length.y)
			Add.y = (length.y - fabs(z.y)) * (length.y - fabs(z.y)) * tgladS.y;
		if (fabs(z.z) > limit.z && fabs(z.z) < length.z)
			Add.z = (length.z - fabs(z.z)) * (length.z - fabs(z.z)) * tgladS.z;
		Add *= fractal->transformCommon.scale3D000;
		z.x = (z.x - (sign(z.x) * (Add.x)));
		z.y = (z.y - (sign(z.y) * (Add.y)));
		z.z = (z.z - (sign(z.z) * (Add.z)));
	}
	REAL4 zCol = z;

	// offset1
	if (aux->i >= fractal->transformCommon.startIterationsM
			&& aux->i < fractal->transformCommon.stopIterationsM)
		z += fractal->transformCommon.offsetA000;

	// spherical fold
	REAL rrCol = dot(z, z);
	REAL m = 1.0f;
	if (fractal->transformCommon.functionEnabledCxFalse
			&& aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		REAL rr = rrCol;
		rrCol = rr;
		if (rr < fractal->transformCommon.minR2p25)
			m = fractal->transformCommon.maxMinR2factor;
		else if (rr < fractal->transformCommon.maxR2d1)
			m = fractal->transformCommon.maxR2d1 / rr;
		z *= m;
		aux->DE *= m;
	}

	if (fractal->transformCommon.functionEnabledCy
			&& aux->i >= fractal->transformCommon.startIterationsX
			&& aux->i < fractal->transformCommon.stopIterationsX)
	{
		REAL rr = dot(z, z);
		REAL rk1 = SmoothConditionALessB(rr, fractal->transformCommon.minR2p25, fractal->transformCommon.scaleA3);
		REAL sm1 = (fractal->transformCommon.maxMinR2factor * rk1) + (1.0f - rk1);

		t = 1.0f;
		if (aux->i >= fractal->transformCommon.startIterationsY
				&& aux->i < fractal->transformCommon.stopIterationsY)
		{
			REAL rk2 = SmoothConditionALessB(rr, fractal->transformCommon.maxR2d1, fractal->transformCommon.scaleB3);
			REAL rk21 = (1.0f - rk1) * rk2;
			t = (1.0f - rk21) + (fractal->transformCommon.maxR2d1 / rr * rk21);
		}
		t = sm1 * t;
		z = z * t;
		aux->DE = aux->DE * t;
	}
	REAL rrCol2 = dot(z, z);
	REAL useScale = 1.0f;
	// scale
	if (aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
	{
		useScale = (aux->actualScaleA + fractal->transformCommon.scale2);
		z *= useScale;
		aux->DE = aux->DE * fabs(useScale) + fractal->analyticDE.offset1;
		if (fractal->transformCommon.functionEnabledKFalse)
		{
			// update actualScaleA for next iteration
			REAL vary = fractal->transformCommon.scaleVary0
									* (fabs(aux->actualScaleA) - fractal->transformCommon.scaleC1);
			aux->actualScaleA = -vary;
		}
	}

	if (fractal->transformCommon.rotationEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	if (fractal->transformCommon.addCpixelEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsG
			&& aux->i < fractal->transformCommon.stopIterationsG)
	{
		z += aux->const_c * fractal->transformCommon.constantMultiplier111;
	}

	if (aux->i >= fractal->transformCommon.startIterationsF
			&& aux->i < fractal->transformCommon.stopIterationsF)
		z += fractal->transformCommon.additionConstantA000;

	if (aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix2, z);

	if (fractal->foldColor.auxColorEnabledFalse
			&& aux->i >= fractal->foldColor.startIterationsA
			&& aux->i < fractal->foldColor.stopIterationsA)
	{
		REAL colorAdd = 0.0f;
		zCol = fabs(zCol - oldZ);
		if (zCol.x > 0.0f) colorAdd += fractal->foldColor.difs0000.x * zCol.x;
		if (zCol.y > 0.0f) colorAdd += fractal->foldColor.difs0000.y * zCol.y;
		if (zCol.z > 0.0f) colorAdd += fractal->foldColor.difs0000.z * zCol.z;
		if (rrCol != rrCol2)
			colorAdd += fractal->foldColor.difs0000.w * fabs(rrCol - rrCol2);

		colorAdd += fractal->mandelbox.color.factorSp1 * t * useScale;

		aux->color += colorAdd;
	}
	return z;
}