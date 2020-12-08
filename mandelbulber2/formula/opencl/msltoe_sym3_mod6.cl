/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * MsltoeJuliaBulb Eiffie. Refer post by Eiffie    Reply #69 on: January 27, 2015
 * @reference http://www.fractalforums.com/theory/choosing-the-squaring-formula-by-location/60/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_msltoe_sym3_mod6.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MsltoeSym3Mod6Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 c = aux->const_c;
	if (fractal->transformCommon.functionEnabled
			&& aux->i >= fractal->transformCommon.startIterationsJ
			&& aux->i < fractal->transformCommon.stopIterationsJ)
	{
		aux->DE = aux->DE * 2.0f * aux->r;

		REAL psi = fractal->transformCommon.int8Y;
		if (fractal->transformCommon.functionEnabledBFalse
				&& aux->i >= fractal->transformCommon.startIterationsB
				&& aux->i < fractal->transformCommon.stopIterationsB)
		{
			psi += fractal->transformCommon.int1;
		}
		psi = M_PI_F / psi;
		psi = fabs(fmod(atan2(z.x, z.y) + M_PI_F + psi, 2.0f * psi) - psi);
		REAL len = native_sqrt(z.y * z.y + z.x * z.x);
		z.y = native_cos(psi) * len;
		z.x = native_sin(psi) * len;

		REAL4 z2 = z * z;
		REAL rr = z2.z + z2.y + z2.x;
		REAL m = 1.0f - z2.x / rr;
		REAL4 temp;
		temp.z = (z2.z - z2.y) * m * fractal->transformCommon.scaleB1;
		temp.y = 2.0f * z.z * z.y * m * fractal->transformCommon.scale; // scaling y;
		temp.x = 2.0f * z.x * native_sqrt(z2.z + z2.y);
		temp.w = z.w;
		z = temp - fractal->transformCommon.offset001;

		if (fractal->transformCommon.addCpixelEnabledFalse
				&& aux->i >= fractal->transformCommon.startIterationsC
				&& aux->i < fractal->transformCommon.stopIterationsC)
		{
			REAL4 tempFAB = c;
			if (fractal->transformCommon.functionEnabledx) tempFAB.x = fabs(tempFAB.x);
			if (fractal->transformCommon.functionEnabledy) tempFAB.y = fabs(tempFAB.y);
			if (fractal->transformCommon.functionEnabledz) tempFAB.z = fabs(tempFAB.z);

			tempFAB *= fractal->transformCommon.constantMultiplier000;
			z.x += sign(z.x) * tempFAB.x;
			z.y += sign(z.y) * tempFAB.y;
			z.z += sign(z.z) * tempFAB.z;
		}
		REAL lengthTempZ = -length(z);
		// if (lengthTempZ > -1e-21f) lengthTempZ = -1e-21f;   //  z is neg.)
		z *= 1.0f + fractal->transformCommon.offset / lengthTempZ;
		z *= fractal->transformCommon.scale1;
		aux->DE *= fabs(fractal->transformCommon.scale1);
	}

	if (fractal->transformCommon.functionEnabledEFalse
			&& aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
	{
		REAL4 zz = z * z;
		REAL leng = native_sqrt(zz.x + zz.y + zz.z); // needed when alternating pwr2s
		aux->DE = leng * aux->DE * 2.0f + 1.0f;

		REAL t = 1.0f;
		REAL temp = zz.y + zz.x;
		if (temp > 0.0f) t = 2.0f * z.z / native_sqrt(temp);
		temp = z.x;
		z.z = (zz.z - zz.y - zz.x);
		z.y = (2.0f * t * z.y * temp);
		z.x = (t * (zz.y - zz.x));
		// c.yz swap
		z.z -= aux->const_c.z * fractal->transformCommon.scaleE1;
		// z.x -= c.y;
		// z.y -= c.x;
	}

	if (fractal->transformCommon.functionEnabledFalse // quaternion fold
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		aux->r = length(z);
		aux->DE = aux->DE * 2.0f * aux->r;
		z = (REAL4){z.x * z.z, z.y * z.z, z.z * z.z - z.y * z.y - z.x * z.x, 0.0f};
		if (!fractal->transformCommon.functionEnabledTFalse)
		{
			z *= (REAL4){2.0f, 2.0f, 1.0f, 1.0f};
			// z.z -= aux->const_c.z * fractal->transformCommon.scaleF1;
			// z.z -= fractal->transformCommon.offset0;
		}
		else
		{
			REAL tempL = length(z);
			z *= (REAL4){2.0f, 2.0f, 1.0f, 1.0f};
			REAL avgScale = length(z) / tempL;
			aux->DE *= avgScale;
		}
		z.z -= aux->const_c.z * fractal->transformCommon.scaleF1;
		z.z -= fractal->transformCommon.offset0;
	}
	if (fractal->transformCommon.angle0 != 0 && aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		REAL tempY = z.y;
		REAL beta = fractal->transformCommon.angle0 * M_PI_180_F;
		z.y = z.y * native_cos(beta) + z.x * native_sin(beta);
		z.x = tempY * -native_sin(beta) + z.x * native_cos(beta);
	}
	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	return z;
}