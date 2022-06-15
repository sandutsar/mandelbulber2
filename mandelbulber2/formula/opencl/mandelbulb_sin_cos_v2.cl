﻿/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2022 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Mandelbulb fractal.
 * @reference http://www.fractalforums.com/3d-fractal-generation/true-3d-mandlebrot-type-fractal/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_mandelbulb_sin_cos.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MandelbulbSinCosV2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL th = z.z / aux->r;
	if (!fractal->transformCommon.functionEnabledBFalse)
	{
		if (!fractal->transformCommon.functionEnabledAFalse)
			th = asin(th);
		else
			th = acos(th);
	}
	else
	{
		th = acos(th) * (1.0f - fractal->transformCommon.scale1)
				 + asin(th) * fractal->transformCommon.scale1;
	}


	REAL ph = atan2(z.y, z.x);
	//if (!fractal->transformCommon.functionEnabledFFalse)

	if (aux->i >= fractal->transformCommon.startIterationsT
			&& aux->i < fractal->transformCommon.stopIterationsT)
	{
		th = (th + fractal->bulb.betaAngleOffset);
		ph = (ph + fractal->bulb.alphaAngleOffset);
	}
	th = (th) * fractal->bulb.power;
	ph = (ph) * fractal->bulb.power;
	REAL rp = native_powr(aux->r, fractal->bulb.power - 1.0f);
	aux->DE = rp * aux->DE * fractal->bulb.power + 1.0f;
	rp *= aux->r;


	if (fractal->transformCommon.functionEnabledAx)
	{
		if (!fractal->transformCommon.functionEnabledEFalse)
		{
			REAL cth = native_cos(th);
			if (!fractal->transformCommon.functionEnabledDFalse)
			{
				z.x = cth * native_cos(ph) ;
				z.y = cth * native_sin(ph);
				z.z = native_sin(th);
			}
			else
			{
				z.x = cth * native_cos(ph) ;
				z.y = native_sin(th);
				z.z = cth * native_sin(ph);
			}
		}
		else
		{
			REAL sth = native_sin(th);
			if (!fractal->transformCommon.functionEnabledDFalse)
			{
				z.x = sth * native_sin(ph);
				z.y = sth * native_cos(ph);
				z.z = native_cos(th);
			}
			else
			{
				z.x = sth * native_sin(ph);
				z.y = native_cos(th);
				z.z = sth * native_cos(ph);
			}
		}
	}
	if (fractal->transformCommon.functionEnabledJFalse)
	{
		REAL sth = native_sin(th);
		REAL4 vsth = (REAL4)(native_cos(ph), native_sin(ph), native_cos(th), 0.0f);
		if (fractal->transformCommon.functionEnabledKFalse) vsth.x *= sth;
		if (fractal->transformCommon.functionEnabledMFalse) vsth.y *= sth;
		if (fractal->transformCommon.functionEnabledNFalse) vsth.z *= sth;

		z = vsth;
	}




/*	if (fractal->transformCommon.functionEnabledJFalse)
	{
		REAL sth = native_sin(th);
		z.x = sth * native_cos(ph);
		z.y = sth * native_sin(ph);
		z.z = native_cos(th);
	}
	if (fractal->transformCommon.functionEnabledKFalse)
	{
		REAL sth = native_sin(th);
		z.x = sth * cos(ph);
		z.y = native_sin(ph);
		z.z = native_cos(th);
	}
	if (fractal->transformCommon.functionEnabledMFalse)
	{
		//REAL sth = native_sin(th);
		z.x = native_cos(ph);
		z.y = native_sin(ph);
		z.z = native_cos(th);
	}
	if (fractal->transformCommon.functionEnabledNFalse)
	{
		REAL sth = native_sin(th);
		z.x = native_cos(ph);
		z.y = native_sin(ph);
		z.z = sth * native_cos(th);
	}*/


	z *= rp;



	z += fractal->transformCommon.offsetA000;
	z += aux->const_c * fractal->transformCommon.constantMultiplierA111;
	z.z *= fractal->transformCommon.scaleA1;

	if (fractal->analyticDE.enabledFalse)
	{
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	}

	if (fractal->transformCommon.functionEnabledCFalse)
	{
		aux->DE0 = length(z);
		if (aux->DE0 > 1.0f)
			aux->DE0 = 0.5f * log(aux->DE0) * aux->DE0 / (aux->DE);
		else
			aux->DE0 = 0.01f; // 0.0f artifacts in openCL

		if (aux->i >= fractal->transformCommon.startIterationsO
				&& aux->i < fractal->transformCommon.stopIterationsO)
			aux->dist = min(aux->dist, aux->DE0);
		else
			aux->dist = aux->DE0;
	}
	return z;
}
