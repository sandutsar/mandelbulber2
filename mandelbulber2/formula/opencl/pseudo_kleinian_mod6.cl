/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Pseudo Kleinian, Knighty - Theli-at's Pseudo Kleinian (Scale 1 JuliaBox + Something
 * @reference https://github.com/Syntopia/Fragmentarium/blob/master/
 * Fragmentarium-Source/Examples/Knighty%20Collection/PseudoKleinian.frag

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_pseudo_kleinian_mod3.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 PseudoKleinianMod6Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL colorAdd = 0.0f;
	REAL k = 0.0f;
	REAL Dk = 1.0f;
	int h = 0;
	for (h = 0; h < fractal->transformCommon.int32; h++)
	{
		// sphere inversion
		if (fractal->transformCommon.sphereInversionEnabledFalse
				&& h >= fractal->transformCommon.startIterationsX
				&& h < fractal->transformCommon.stopIterations1)
		{
			z += fractal->transformCommon.offset000;
			REAL rr = dot(z, z);
			z *= fractal->transformCommon.scaleG1 / rr;
			Dk *= (fractal->transformCommon.scaleG1 / rr);
			z += fractal->transformCommon.additionConstantP000 - fractal->transformCommon.offset000;
			z *= fractal->transformCommon.scaleA1;
			Dk *= fractal->transformCommon.scaleA1;
		}

		// box offset
		if (h >= fractal->transformCommon.startIterationsM
				&& h < fractal->transformCommon.stopIterationsM)
		{
			z.x -= fractal->transformCommon.constantMultiplier000.x * sign(z.x);
			z.y -= fractal->transformCommon.constantMultiplier000.y * sign(z.y);
			z.z -= fractal->transformCommon.constantMultiplier000.z * sign(z.z);
		}

		// Pseudo kleinian
		if (h >= fractal->transformCommon.startIterationsC
				&& h < fractal->transformCommon.stopIterationsC)
		{
			z = fabs(z + fractal->transformCommon.additionConstant0777)
					- fabs(z - fractal->transformCommon.additionConstant0777) - z;
			k = max(fractal->transformCommon.minR05 / dot(z, z), 1.0f);
			z *= k;
			Dk *= k;
		}

		z += fractal->transformCommon.additionConstant000;

		if (fractal->transformCommon.functionEnabledGFalse
					&& h >= fractal->transformCommon.startIterationsG
					&& h < fractal->transformCommon.stopIterationsG)
		{
			z.x += aux->pos_neg * fractal->transformCommon.additionConstantA000.x;
			z.y += aux->pos_neg * fractal->transformCommon.additionConstantA000.y;
			z.z += aux->pos_neg * fractal->transformCommon.additionConstantA000.z;

			aux->pos_neg *= fractal->transformCommon.scaleNeg1;
		}

		if (fractal->transformCommon.addCpixelEnabledFalse
				&& h >= fractal->transformCommon.startIterationsT
				&& h < fractal->transformCommon.stopIterationsT1) // symmetrical addCpixel
		{
			REAL4 tempFAB = aux->const_c;
			if (fractal->transformCommon.functionEnabledx) tempFAB.x = fabs(tempFAB.x);
			if (fractal->transformCommon.functionEnabledy) tempFAB.y = fabs(tempFAB.y);
			if (fractal->transformCommon.functionEnabledz) tempFAB.z = fabs(tempFAB.z);

			tempFAB *= fractal->transformCommon.scale3D000;
			z.x -= sign(z.x) * tempFAB.x;
			z.y -= sign(z.y) * tempFAB.y;
			z.z -= sign(z.z) * tempFAB.z;
		}

		if (fractal->transformCommon.rotationEnabledFalse
				&& h >= fractal->transformCommon.startIterationsR
				&& h < fractal->transformCommon.stopIterationsR1)
		{
			z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
		}

		if (fractal->transformCommon.functionEnabledxFalse) z.x = -z.x;
		if (fractal->transformCommon.functionEnabledyFalse) z.y = -z.y;
	}

	// pk dist functions
	REAL4 q = z;
	REAL temp = q.x * q.x + q.y * q.y;
	REAL rxy = native_sqrt(temp);

	if (fractal->transformCommon.functionEnabledAx)
	{
		REAL d1 = temp + q.z * q.z;

		if (!fractal->transformCommon.functionEnabledAyFalse) d1 = native_sqrt(d1);

		d1 = (fabs(rxy * q.z) - fractal->transformCommon.offsetD0)
					/ (d1 + fractal->transformCommon.offset02);
		aux->DE0 = d1;
	}

	if (fractal->transformCommon.functionEnabledAzFalse)
	{
		REAL d3 = fabs(fractal->transformCommon.scale05 * fabs(q.z - fractal->transformCommon.offsetA0));

		if (!fractal->transformCommon.functionEnabledAwFalse) aux->DE0 = d3;
		else aux->DE0 = min(aux->DE0, d3);
	}

	if (fractal->transformCommon.functionEnabledCFalse)
	{
		q.x = q.x * q.x * fractal->transformCommon.scaleC1;
		q.y	= q.y * q.y * fractal->transformCommon.scaleD1;
		if (fractal->transformCommon.functionEnabledNFalse)
		{
			q.x *= q.x;
			q.y *= q.y;
		}
		rxy = native_sqrt(q.x + q.y);
		aux->DE0 = max(rxy - fractal->transformCommon.offsetA1, aux->DE0);
	}
	aux->DE0 /= Dk;
	k = aux->DE0;

	// KaliBoxMod
	if (fractal->transformCommon.functionEnabledFFalse)
	{
		REAL4 p = z;
		REAL m =1.0f;
		REAL r2 = 0.0f;
		temp = fractal->transformCommon.maxR2d1 / fractal->transformCommon.minR2p25;
		REAL Dd = 1.0f;
		for (int n = 0; n < fractal->transformCommon.int16 && r2 < 100.0f; n++)
		{
			m = 1.0f;
			p = fractal->transformCommon.additionConstant0555 - fabs(p);
			r2 = dot(p, p);
			if (r2 < fractal->transformCommon.minR2p25) m = temp;
			else if (r2 < fractal->transformCommon.maxR2d1) m = fractal->transformCommon.maxR2d1 / r2;

			m *= fractal->transformCommon.scale015;
			p = p * m + fractal->transformCommon.offsetF000;
			Dd = Dd * m + fractal->analyticDE.offset1;
		}
		REAL r = sqrt(r2);
		if (!fractal->transformCommon.functionEnabledTFalse) Dd = r / fabs(Dd);
		else Dd = 0.5f * r * log(r) / fabs(Dd);

		if (!fractal->transformCommon.functionEnabledIFalse) aux->DE0 =
				min(fractal->transformCommon.scale025 * Dd, fractal->transformCommon.scaleB1 * aux->DE0);
		else aux->DE0 = max(fractal->transformCommon.offset0005 * Dd, aux->DE0);
	}

	if (fractal->transformCommon.functionEnabledDFalse) aux->DE0 = min(aux->dist, aux->DE0);
	if (fractal->analyticDE.enabledFalse) aux->DE = Dk;
	aux->dist = aux->DE0;

	// color
	if (fractal->foldColor.auxColorEnabledFalse)
	{
		if (aux->DE0 != k) colorAdd = fractal->foldColor.difs0000.w;
		else
		{
			colorAdd += fractal->foldColor.difs0000.x * rxy;
			colorAdd += fractal->foldColor.difs0000.y * k;
			colorAdd += fractal->foldColor.difs0000.z * fabs(q.z);
		}
		aux->color += colorAdd;
	}
	return z;
}
