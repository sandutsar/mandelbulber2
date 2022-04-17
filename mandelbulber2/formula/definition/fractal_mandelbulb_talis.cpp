/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.         ______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,      / ____/ __    __
 *                                        \><||i|=>>%)     / /   __/ /___/ /_
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    / /__ /_  __/_  __/
 * The project is licensed under GPLv3,   -<>>=|><|||`    \____/ /_/   /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Mandelbulb fractal.
 * @reference http://www.fractalforums.com/3d-fractal-generation/true-3d-mandlebrot-type-fractal/
 */

#include "all_fractal_definitions.h"

cFractalMandelbulbTalis::cFractalMandelbulbTalis() : cAbstractFractal()
{
	nameInComboBox = "Mandelbulb Talis";
	internalName = "mandelbulb_talis";
	internalID = fractal::mandelbulbTalis;
	DEType = analyticDEType;
	DEFunctionType = logarithmicDEFunction;
	cpixelAddition = cpixelEnabledByDefault;
	defaultBailout = 10.0;
	DEAnalyticFunction = analyticFunctionLogarithmic;
	coloringFunction = coloringFunctionDefault;
}

void cFractalMandelbulbTalis::FormulaCode(CVector4 &z, const sFractal *fractal, sExtendedAux &aux)
{
	double th = z.z / aux.r;
	if (!fractal->transformCommon.functionEnabledBFalse)
	{
		if (!fractal->transformCommon.functionEnabledAFalse) th = asin(th);
		else th = acos(th);
	}
	else
	{
		th = acos(th) * (1.0 - fractal->transformCommon.scale1)
				+ asin(th) * fractal->transformCommon.scale1;
	}
	th = (th + fractal->bulb.betaAngleOffset) * fractal->bulb.power;
	double ph = (atan2(z.y, z.x) + fractal->bulb.alphaAngleOffset) * fractal->bulb.power;
	double rp = pow(aux.r, fractal->bulb.power - 1.0);
	aux.DE = rp * aux.DE * fractal->bulb.power + 1.0;
	rp *= aux.r;
	double cth = cos(th);
	z.x = cth * cos(ph) * rp;
	z.y = cth * sin(ph) * rp;
	z.z = sin(th) * rp;
	z += fractal->transformCommon.offsetA000;
	//z += aux.const_c * fractal->transformCommon.constantMultiplierA111;
	z.z *= fractal->transformCommon.scaleA1;

	//=================================================
	/// calculate 'Tails' part Z=(Z+1/Z)/2+C

	/// calculate 1/Z
	// radius squared
	//aux->r = z.x * z.x + z.y * z.y + z.z * z.z;
	aux.r = 1.0 / z.Dot(z);
	/// 1/z = conj(z)/r^2
	CVector4 t = z;
	t.x = -z.x;
	t.z = -z.z;
	t.y = z.y;

CVector4 g = fractal->transformCommon.scale3D111;
//REAL g = fractal->transformCommon.scaleA1;
t *= g *  aux.r;
	///========================================
	/// puting z, 1/z and C together.

	z.x = (z.x + t.x) * fractal->transformCommon.scaleB1;
	z.y = (z.y + t.y) * fractal->transformCommon.scaleB1;
	z.z = (z.z + t.z) * fractal->transformCommon.scaleB1;
	aux.DE *= fractal->transformCommon.scaleB1;





	if (fractal->analyticDE.enabledFalse)
	{
		aux.DE = aux.DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	}

	if (fractal->transformCommon.functionEnabledCFalse)
	{
		aux.DE0 = z.Length();
		if (aux.DE0 > 1.0)
			aux.DE0 = 0.5 * log(aux.DE0) * aux.DE0 / (aux.DE);
		else
			aux.DE0 = 0.01; // 0.0 artifacts in openCL

		if (aux.i >= fractal->transformCommon.startIterationsO
					&& aux.i < fractal->transformCommon.stopIterationsO)
			aux.dist = min(aux.dist, aux.DE0);
		else
			aux.dist = aux.DE0;
	}
}
