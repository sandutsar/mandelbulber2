/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Classic Mandelbulb fractal.
 * @reference http://www.fractalforums.com/3d-fractal-generation/true-3d-mandlebrot-type-fractal/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_mandelbulb.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MandelbulbSinCosIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL temp, th, ph, rp, cth;
	if (fractal->transformCommon.functionEnabled
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		temp = fractal->transformCommon.pwr8 + 1.0f;
		th = (asin(z.z / aux->r) + fractal->bulb.betaAngleOffset) * temp;
		ph = (atan2(z.y, z.x) + fractal->bulb.alphaAngleOffset) * temp;
		rp = native_powr(aux->r, fractal->transformCommon.pwr8);
		aux->DE = rp * aux->DE * temp + 1.0f;
		rp *= aux->r;
		cth = native_cos(th);
		z.x = cth * native_cos(ph) * rp;
		z.y = cth * native_sin(ph) * rp;
		z.z = native_sin(th) * rp;
		z += fractal->transformCommon.offsetA000;
		z += aux->const_c * fractal->transformCommon.constantMultiplierA111;
	}

	if (fractal->transformCommon.functionEnabledBFalse
			&& aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{
		aux->r = length(z);
		temp = fractal->transformCommon.scale8 + 1.0f;
		th = (acos(z.z / aux->r) + fractal->transformCommon.offsetB0) * temp;
		ph = (atan2(z.y, z.x) + fractal->transformCommon.offsetA0) * temp;
		rp = native_powr(aux->r, fractal->transformCommon.scale8);
		aux->DE = rp * aux->DE * temp + 1.0f;
		rp *= aux->r;
		cth = native_cos(th);
		z.x = cth * native_cos(ph) * rp;
		z.y = cth * native_sin(ph) * rp;
		z.z = native_sin(th) * rp;
		z += fractal->transformCommon.offset000;
		z += aux->const_c * fractal->transformCommon.constantMultiplierB111;
	}

	if (fractal->analyticDE.enabledFalse)
	{
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	}

	if (fractal->analyticDE.enabled)
	{
		aux->DE0 = length(z);
		aux->DE0 = 0.5f * log(aux->DE0) * aux->DE0 / (aux->DE);
		if (aux->i >= fractal->transformCommon.startIterationsO
				&& aux->i < fractal->transformCommon.stopIterationsO)
			aux->dist = min(aux->dist, aux->DE0);
		else
			aux->dist = aux->DE0;
	}
	return z;
}