/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDifsTorusV3Iteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_torus_twist.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfSincosHelixIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL temp;
	REAL ang;
	if (fractal->transformCommon.functionEnabledPFalse)
	{
		if (aux->i >= fractal->transformCommon.startIterationsP
				&& aux->i < fractal->transformCommon.stopIterationsP1)
		{
			// pre abs
			if (fractal->transformCommon.functionEnabledxFalse)
			{
				if (!fractal->transformCommon.functionEnabledBxFalse) z.x = fabs(z.x);
				else z.x = -fabs(z.x);
			}
			if (fractal->transformCommon.functionEnabledyFalse)
			{
				if (!fractal->transformCommon.functionEnabledByFalse) z.y = fabs(z.y);
				else z.y = -fabs(z.y);
			}
			if (fractal->transformCommon.functionEnabledzFalse)
			{
				if (!fractal->transformCommon.functionEnabledBzFalse) z.z = fabs(z.z);
				else z.z = -fabs(z.z);
			}
			// addition constant
			z += fractal->transformCommon.additionConstantA000;
		}

		if (aux->i >= fractal->transformCommon.startIterationsC
				&& aux->i < fractal->transformCommon.stopIterationsC1)
		{
			if (fractal->transformCommon.functionEnabledCxFalse)
			{
				ang = M_PI_F / fractal->transformCommon.int8X;
				ang = fabs(fmod(atan2(z.y, z.x) + ang, 2.0f * ang) - ang);
				temp = native_sqrt(z.x * z.x + z.y * z.y);
				z.x = native_cos(ang) * temp;
				z.y = native_sin(ang) * temp;
			}
			if (fractal->transformCommon.functionEnabledCyFalse)
			{
				ang = M_PI_F / fractal->transformCommon.int8Y;
				ang = fabs(fmod(atan2(z.z, z.y) + ang, 2.0f * ang) - ang);
				temp = native_sqrt(z.y * z.y + z.z * z.z);
				z.y = native_cos(ang) * temp;
				z.z = native_sin(ang) * temp;
			}
			if (fractal->transformCommon.functionEnabledCzFalse)
			{
				ang = M_PI_F / fractal->transformCommon.int8Z;
				ang = fabs(fmod(atan2(z.x, z.z) + ang, 2.0f * ang) - ang);
				temp = native_sqrt(z.z * z.z + z.x * z.x);
				z.z = native_cos(ang) * temp;
				z.x = native_sin(ang) * temp;
			}
			// addition constant
			z += fractal->transformCommon.additionConstant000;
		}

		// rotation
		if (aux->i >= fractal->transformCommon.startIterationsR
				&& aux->i < fractal->transformCommon.stopIterationsR1)
			z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	// swap axis
	if (fractal->transformCommon.functionEnabledSwFalse)
	{
		temp = z.x;
		z.x = z.y;
		z.y = temp;
	}

	// swap axis
	if (fractal->transformCommon.functionEnabledSFalse)
	{
		temp = z.x;
		z.x = z.z;
		z.z = temp;
	}

	z *= fractal->transformCommon.scale1;
	aux->DE = fabs(aux->DE * fractal->transformCommon.scale1);

	if (!fractal->transformCommon.functionEnabledOFalse)
		ang = atan2(z.x, z.y);
	else
		ang = atan2(z.y, z.x);
	ang *= M_PI_2x_INV_F * fractal->transformCommon.scaleA1;

	if (fractal->transformCommon.functionEnabled)
		z.y = sqrt(z.x * z.x + z.y * z.y) - fractal->transformCommon.scale015;

	if (fractal->transformCommon.functionEnabledAFalse)
	{
		z.x += z.z * fractal->transformCommon.scaleB0;
		z.y += z.z * fractal->transformCommon.scaleC0;
	}

	// vert helix
	if (fractal->transformCommon.functionEnabledAx)
	{
		REAL Voff = fractal->transformCommon.offset4;
		temp = z.z - Voff * ang * fractal->transformCommon.int1 + Voff * 0.5f;
		z.z = temp - Voff * floor(temp / (Voff)) - Voff * 0.5f;
	}

	// stretch
	if (fractal->transformCommon.functionEnabledAw)
	{
		if (!fractal->transformCommon.functionEnabledAy)
			z.x = fractal->transformCommon.offsetR1;
		else
		{
			temp = fractal->transformCommon.scale16 * ang
					+ fractal->transformCommon.offsetR1;
			z.x = temp - 2.0f * floor(temp * 0.5f) - 1.0f;
		}
	}

	if (fractal->transformCommon.functionEnabledAzFalse)
	{
		if (fractal->transformCommon.functionEnabledAwFalse)
		{
			REAL Phi = z.z;
			REAL Rho = native_sqrt(z.x * z.x + z.y * z.y);

			ang = Rho * fractal->transformCommon.offsetA0
					+ Phi * fractal->transformCommon.offsetB0;
		}
		REAL cosA = native_cos(ang);
		REAL sinB = native_sin(ang);

		if (!fractal->transformCommon.functionEnabledNFalse)
		{
			temp = z.x;
			z.x = z.y * cosA + z.x * sinB;
		}
		else
		{
			temp = z.z;
			z.z = z.y * cosA + z.z * sinB;
		}
		z.y = temp * cosA - z.y * sinB;
	}

	if (fractal->transformCommon.functionEnabledMFalse)
	{
		if ( z.z < (fractal->transformCommon.offsetA1 + 0.5) * fractal->transformCommon.offset2
			&& z.z > (fractal->transformCommon.offsetT1 + 0.5) * -fractal->transformCommon.offset2)
		{
			z.z -= round(z.z / fractal->transformCommon.offset2) * fractal->transformCommon.offset2;
			z.z = clamp(fabs(z.z), -fractal->transformCommon.offset1, fractal->transformCommon.offset1);

			// clip
			if (fractal->transformCommon.functionEnabledEFalse)
				z.z = max(aux->const_c.z - fractal->transformCommon.offsetE0, z.z);

			if (fractal->transformCommon.functionEnabledFFalse)
				z.z = min(aux->const_c.z + fractal->transformCommon.offsetF0, -z.z);
		}
	}

	// Analytic DE tweak
	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;

	// aux->color
	if (fractal->foldColor.auxColorEnabled)
	{
		if (!fractal->transformCommon.functionEnabledGFalse)
		{
			ang = (M_PI_F - 2.0f * fabs(atan(fractal->foldColor.difs1 * z.y / z.z)))
					* 4.0 * M_PI_2x_INV_F;
			if (fmod(ang, 2.0f) < 1.0f) aux->color += fractal->foldColor.difs0000.z;
			else aux->color += fractal->foldColor.difs0000.y;
		}
		else
		{
			aux->color += fractal->foldColor.difs0000.x * (z.x * z.x);
			aux->color += fractal->foldColor.difs0000.z * (z.z * z.z);
			aux->color += fractal->foldColor.difs0000.y * (z.y * z.y);
		}
	}
	return z;
}