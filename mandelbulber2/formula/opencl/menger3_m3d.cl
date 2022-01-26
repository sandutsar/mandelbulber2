/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Menger Sponge code by Knighty

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_menger3_m3d.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 Menger3M3dIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	z = fabs(z);
	z += fractal->transformCommon.offset000;

	z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrixXYZ, z);

	REAL t;
	t = z.x - z.y;
	t = 0.5f * (t - fabs(t));
	z.x = z.x - t;
	z.y = z.y + t;

	t = z.x - z.z;
	t = 0.5f * (t - fabs(t));
	z.z = z.z + t;
	z.x = z.x - t;

	t = z.y - z.z;
	t = 0.5f * (t - fabs(t));
	z.y = z.y - t;
	z.z = z.z + t;

	z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix2XYZ, z);

	REAL sc1 = fractal->transformCommon.scale3 - 1.0f;
	REAL sc2 = 0.5f * sc1 / fractal->transformCommon.scale3;
	z.z = z.z - fractal->transformCommon.offset111.z * sc2;
	z.z = -fabs(z.z) + fractal->transformCommon.offset111.z * sc2;

	z.x = fractal->transformCommon.scale3 * z.x - fractal->transformCommon.offset111.x * sc1;
	z.y = fractal->transformCommon.scale3 * z.y - fractal->transformCommon.offset111.y * sc1;
	z.z = fractal->transformCommon.scale3 * z.z;

	aux->DE *= fractal->transformCommon.scale3;

	// Analytic DE tweak
	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	return z;
}