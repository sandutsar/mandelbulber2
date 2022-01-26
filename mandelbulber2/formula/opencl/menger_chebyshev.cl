/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Menger Sponge formula modified by Mclarekin
 * from code by Knighty
 * Chebyshev rotation from eiffie

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_menger_chebyshev.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MengerChebyshevIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	// chebyshev rotation
	if (aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC1)
	{
		if (fractal->transformCommon.functionEnabledSwFalse)
		{
			REAL temp = z.x;
			z.x = z.y;
			z.y = temp;
		}
		REAL tmp = 0.0f;
		REAL F = z.x / z.y;
		if (z.y == 0.0f) tmp = (z.x > 0.0f ? 0.0 : 4.0f);
		if (fabs(F) < 1.0f)
		{
			if (z.y > 0.0f)
				tmp = 2.0f - F;
			else
				tmp = 6.0f - F;
		}
		else
		{
			F = z.y / z.x;
			if (z.x > 0.0f)
				tmp = fmod(F, 8.0f);
			else
				tmp = 4.0f + F;
		}

		tmp = tmp + fractal->transformCommon.offset1;

		REAL Length2 = max(fabs(z.x), fabs(z.y));

		REAL C = tmp - 8.0f * floor(tmp / 8.0f);

		C = fabs(C - 4.0f) - 2.0f;
		z.x = clamp(C, -1.0f, 1.0f) * Length2;

		REAL S = tmp - 2.0f;
		S = S - 8.0f * floor(S / 8.0f);
		S = fabs(S - 4.0f) - 2.0f;
		z.y = clamp(S, -1.0f, 1.0f) * Length2;
		aux->DE *= SQRT_1_2_F * 2.0f;
	}

	z = fabs(z);

	// rotation
	if (fractal->transformCommon.rotationEnabled && aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	if (z.x < z.y)
	{
		REAL temp = z.y;
		z.y = z.x;
		z.x = temp;
	}
	if (z.x < z.z)
	{
		REAL temp = z.z;
		z.z = z.x;
		z.x = temp;
	}
	if (z.y < z.z)
	{
		REAL temp = z.z;
		z.z = z.y;
		z.y = temp;
	}

	z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix2, z);

	z = z * fractal->transformCommon.scale3 - fractal->transformCommon.offset222;
	aux->DE = aux->DE * fractal->transformCommon.scale3 + fractal->analyticDE.offset0;
	if (z.z < -1.0f) z.z += 2.0f;

	// boxoffset
	if (fractal->transformCommon.functionEnabledxFalse
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA) // box offset
	{
		REAL4 temp = z;
		z.x = sign(z.x) * fractal->transformCommon.additionConstantA000.x + z.x;
		z.y = sign(z.y) * fractal->transformCommon.additionConstantA000.y + z.y;
		z.z = sign(z.z) * fractal->transformCommon.additionConstantA000.z + z.z;

		if (fractal->transformCommon.functionEnabledFalse)
		{
			REAL tempL = length(temp);
			// if (tempL < 1e-21f) tempL = 1e-21f;
			REAL avgScale = length(z) / tempL;
			aux->DE = aux->DE * avgScale + 1.0f;
		}
	}

	return z;
}