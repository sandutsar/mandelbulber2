/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Sierpinski3D. made from DarkBeam's Sierpinski code from M3D
 * @reference
 * http://www.fractalforums.com/mandelbulb-3d/custom-formulas-and-transforms-release-t17106/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_sierpinski3d.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 Sierpinski3dIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 temp = z;

	// Normal full tetra-fold;
	if (fractal->transformCommon.functionEnabled)
	{
		if (z.x + z.y < 0.0f)
		{
			temp.x = -z.y;
			z.y = -z.x;
			z.x = temp.x;
		}
		if (z.x + z.z < 0.0f)
		{
			temp.x = -z.z;
			z.z = -z.x;
			z.x = temp.x;
		}
		if (z.y + z.z < 0.0f)
		{
			temp.y = -z.z;
			z.z = -z.y;
			z.y = temp.y;
		}
	}

	// Reversed full tetra-fold;
	if (fractal->transformCommon.functionEnabledFalse)
	{
		if (z.x - z.y < 0.0f)
		{
			REAL temp = z.y;
			z.y = z.x;
			z.x = temp;
		}
		if (z.x - z.z < 0.0f)
		{
			REAL temp = z.z;
			z.z = z.x;
			z.x = temp;
		}
		if (z.y - z.z < 0.0f)
		{
			REAL temp = z.z;
			z.z = z.y;
			z.y = temp;
		}
	}

	z *= fractal->transformCommon.scaleA2;

	if (aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC)
	{
		z -= fractal->transformCommon.offset111; // neg offset
	}
	// rotation
	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	if (!fractal->analyticDE.enabledFalse)
		aux->DE *= fabs(fractal->transformCommon.scaleA2);
	else
		aux->DE = mad(aux->DE * fabs(fractal->transformCommon.scaleA2), fractal->analyticDE.scale1,
			fractal->analyticDE.offset0);
	return z;
}
