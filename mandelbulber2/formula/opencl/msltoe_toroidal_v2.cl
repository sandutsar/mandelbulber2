/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * MsltoeToroidal
 * @reference http://www.fractalforums.com/theory/toroidal-coordinates/msg9428/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_msltoe_toroidal.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MsltoeToroidalV2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (fractal->transformCommon.functionEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsD
			&& aux->i < fractal->transformCommon.stopIterationsD1) // pre-scale
	{
		z *= fractal->transformCommon.scale3D111;
		aux->DE *= length(z) / aux->r;
	}

	REAL temp;
	// Toroidal bulb
	REAL r1 = fractal->transformCommon.minR05; // default 0.5f
	REAL theta = atan2(z.y, z.x);
	REAL x1 = r1 * cos(theta);
	REAL y1 = r1 * sin(theta);

	REAL rr = rr = (z.x - x1) * (z.x - x1) + (z.y - y1) * (z.y - y1);
	REAL r = sqrt(rr + z.z * z.z);
	temp = r;

	if (fractal->transformCommon.functionEnabledXFalse
			&& aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{
		if (fractal->transformCommon.functionEnabledBFalse) temp = rr;
		if (fractal->transformCommon.functionEnabledCFalse) temp = sqrt(rr);
	}

	REAL phi = 0.0f;
	if (!fractal->transformCommon.functionEnabledYFalse)
		phi = atan2(z.z, temp);
	else
		phi = asin(z.z / temp);

	r = r + (aux->r - r) * fractal->transformCommon.offsetR0;

	REAL rp = pow(r, fractal->bulb.power - 1.0f) / fractal->transformCommon.scaleB1;
	aux->DE = rp * aux->DE * (fractal->bulb.power + fractal->analyticDE.offset0) + 1.0f;
	rp *= r;

	phi *= fractal->transformCommon.pwr8; // default 8
	theta *= fractal->bulb.power; // default 9 gives 8 symmetry

	// convert back to cartesian coordinates
	temp = rp * cos(phi);
	z.x = (sign(z.x) * x1 + temp) * cos(theta);
	z.y = (sign(z.y) * y1 + temp) * sin(theta);
	z.z = rp * sin(phi);

	z.z *= fractal->transformCommon.scaleA1;
	aux->DE *= fractal->analyticDE.scale1;

	if (fractal->transformCommon.functionEnabledAxFalse) // spherical offset
	{
		REAL lengthTempZ = -length(z);
		// if (lengthTempZ > -1e-21f) lengthTempZ = -1e-21f;   //  z is neg.)
		z *= 1.0f + fractal->transformCommon.offset / lengthTempZ;
		z *= fractal->transformCommon.scale;
		aux->DE = aux->DE * fabs(fractal->transformCommon.scale) + 1.0f;
	}
	// then add Cpixel constant vector
	return z;
}
