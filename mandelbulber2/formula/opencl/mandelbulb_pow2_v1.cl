/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * MandelbulbPow2 v2  buffalo , Quick Dudley types and makin3D-2
 * @reference http://www.fractalforums.com/3d-fractal-generation/another-shot-at-the-holy-grail/
 * and http://www.fractalgallery.co.uk/ and https://www.facebook.com/david.makin.7

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_mandelbulb_pow2_v2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MandelbulbPow2V1Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{

	if (fractal->transformCommon.functionEnabledAxFalse
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		if (fractal->transformCommon.functionEnabledCxFalse) z.x = fabs(z.x);
		if (fractal->transformCommon.functionEnabledCyFalse) z.y = fabs(z.y);
		if (fractal->transformCommon.functionEnabledCzFalse) z.z = fabs(z.z);
	}

	if (fractal->transformCommon.functionEnabledAyFalse
			&& aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{

		REAL m2 = z.x * z.x + z.y * z.y;
		aux->DE = aux->DE * 2.0f * sqrt(m2 + z.z * z.z) + 1.0f;
		if (m2 == 0.0f)
		{
			z.y = -z.z * z.z;
			z.z = 0.0f;
		}
		else
		{
			REAL temp = m2 - z.z * z.z;
			z.z = 2.0f * sqrt(m2) * z.z;
			//if (fractal->transformCommon.functionEnabledAFalse && z.x < 0.0) z.z = -z.z;
			//if (fractal->transformCommon.functionEnabledBFalse && z.z < 0.0) z.x = -z.x;
			m2 = temp / m2;
			temp = 2.0f * z.x * z.y * m2;
			z.y = (z.y * z.y - z.x * z.x) * m2;
			if (!fractal->transformCommon.functionEnabledAFalse)
				z.x = temp;
			else
				z.x = -temp;
			if (fractal->transformCommon.functionEnabledDFalse)
			{
				z.z *= aux->pos_neg;
				aux->pos_neg *= -1.0f;
			}
		}
	}

	if (fractal->transformCommon.functionEnabledAzFalse
			&& aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC)
	{
		REAL m2 = z.x * z.x + z.z * z.z;
		aux->DE = aux->DE * 2.0f * sqrt(m2 + z.y * z.y) + 1.0f;
		REAL temp = -(m2 - z.y * z.y);

		z.y = 2.0f * sqrt(m2) * z.y;
		//if (fractal->transformCommon.functionEnabledAFalse && z.y < 0.0f) z.x = -z.x;
		//if (fractal->transformCommon.functionEnabledBFalse && z.x < 0.0f) z.y = -z.y;
		m2 = temp / m2;
		temp = 2.0f * z.x * z.z * m2;
		z.z = (z.z * z.z - z.x * z.x) * m2;
		if (!fractal->transformCommon.functionEnabledBFalse)
			z.x = temp;
		else
			z.x = -temp;
		if (fractal->transformCommon.functionEnabledDFalse)
		{
			z.y *= aux->pos_neg;
			aux->pos_neg *= -1.0f;
		}
	}




	// Analytic DE tweak
	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	return z;
}
