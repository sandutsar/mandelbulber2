/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Mandelbox Menger Sponge Hybrid
 * @reference
 * http://www.fractalforums.com/ifs-iterated-function-systems/amazing-fractal/msg12467/#msg12467
 * This formula contains aux.color

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_mandelbox_menger.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MandelboxMengerIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 c = aux->const_c;
	REAL colorAdd = 0.0f;
	if (fractal->mandelbox.rotationsEnabled)
	{
		REAL4 zRot;
		// cast vector to array pointer for address taking of components in opencl
		REAL *zRotP = (REAL *)&zRot;
		__constant REAL *colP = (__constant REAL *)&fractal->mandelbox.color.factor;
		for (int dim = 0; dim < 3; dim++)
		{
			// handle each dimension x, y and z sequentially in pointer var dim
			REAL *rotDim = (dim == 0) ? &zRotP[0] : ((dim == 1) ? &zRotP[1] : &zRotP[2]);
			__constant REAL *colorFactor = (dim == 0) ? &colP[0] : ((dim == 1) ? &colP[1] : &colP[2]);

			zRot = Matrix33MulFloat4(fractal->mandelbox.rot[0][dim], z);
			if (*rotDim > fractal->mandelbox.foldingLimit)
			{
				*rotDim = fractal->mandelbox.foldingValue - *rotDim;
				z = Matrix33MulFloat4(fractal->mandelbox.rotinv[0][dim], zRot);
				colorAdd += *colorFactor;
			}
			else
			{
				zRot = Matrix33MulFloat4(fractal->mandelbox.rot[1][dim], z);
				if (*rotDim < -fractal->mandelbox.foldingLimit)
				{
					*rotDim = -fractal->mandelbox.foldingValue - *rotDim;
					z = Matrix33MulFloat4(fractal->mandelbox.rotinv[1][dim], zRot);
					colorAdd += *colorFactor;
				}
			}
		}
	}
	else
	{
		if (aux->i >= fractal->transformCommon.startIterationsA
				&& aux->i < fractal->transformCommon.stopIterationsA)
		{
			if (fabs(z.x) > fractal->mandelbox.foldingLimit)
			{
				z.x = sign(z.x) * fractal->mandelbox.foldingValue - z.x;
				colorAdd += fractal->mandelbox.color.factor.x;
			}
			if (fabs(z.y) > fractal->mandelbox.foldingLimit)
			{
				z.y = sign(z.y) * fractal->mandelbox.foldingValue - z.y;
				colorAdd += fractal->mandelbox.color.factor.y;
			}
			REAL zLimit = fractal->mandelbox.foldingLimit * fractal->transformCommon.scale1;
			REAL zValue = fractal->mandelbox.foldingValue * fractal->transformCommon.scale1;
			if (fabs(z.z) > zLimit)
			{
				z.z = sign(z.z) * zValue - z.z;
				colorAdd += fractal->mandelbox.color.factor.z;
			}
		}
	}

	if (aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{
		REAL r2 = dot(z, z);
		z += fractal->mandelbox.offset;
		if (r2 < fractal->mandelbox.mR2)
		{
			z *= fractal->mandelbox.mboxFactor1;
			aux->DE *= fractal->mandelbox.mboxFactor1;
			colorAdd += fractal->mandelbox.color.factorSp1;
		}
		else if (r2 < fractal->mandelbox.fR2)
		{
			REAL tglad_factor2 = fractal->mandelbox.fR2 / r2;
			z *= tglad_factor2;
			aux->DE *= tglad_factor2;
			colorAdd += fractal->mandelbox.color.factorSp2;
		}
		z -= fractal->mandelbox.offset;
	}
	if (fractal->mandelbox.mainRotationEnabled && aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
		z = Matrix33MulFloat4(fractal->mandelbox.mainRot, z);

	if (aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		z = z * fractal->mandelbox.scale;
		aux->DE = aux->DE * fabs(fractal->mandelbox.scale) + 1.0f;
	}

	if (fractal->transformCommon.addCpixelEnabledFalse)
	{
		REAL4 tempC = c;
		if (fractal->transformCommon.alternateEnabledFalse) // alternate
		{
			tempC = aux->c;
			switch (fractal->mandelbulbMulti.orderOfXYZ)
			{
				case multi_OrderOfXYZCl_xyz:
				default: tempC = (REAL4){tempC.x, tempC.y, tempC.z, tempC.w}; break;
				case multi_OrderOfXYZCl_xzy: tempC = (REAL4){tempC.x, tempC.z, tempC.y, tempC.w}; break;
				case multi_OrderOfXYZCl_yxz: tempC = (REAL4){tempC.y, tempC.x, tempC.z, tempC.w}; break;
				case multi_OrderOfXYZCl_yzx: tempC = (REAL4){tempC.y, tempC.z, tempC.x, tempC.w}; break;
				case multi_OrderOfXYZCl_zxy: tempC = (REAL4){tempC.z, tempC.x, tempC.y, tempC.w}; break;
				case multi_OrderOfXYZCl_zyx: tempC = (REAL4){tempC.z, tempC.y, tempC.x, tempC.w}; break;
			}
			aux->c = tempC;
		}
		else
		{
			switch (fractal->mandelbulbMulti.orderOfXYZ)
			{
				case multi_OrderOfXYZCl_xyz:
				default: tempC = (REAL4){c.x, c.y, c.z, c.w}; break;
				case multi_OrderOfXYZCl_xzy: tempC = (REAL4){c.x, c.z, c.y, c.w}; break;
				case multi_OrderOfXYZCl_yxz: tempC = (REAL4){c.y, c.x, c.z, c.w}; break;
				case multi_OrderOfXYZCl_yzx: tempC = (REAL4){c.y, c.z, c.x, c.w}; break;
				case multi_OrderOfXYZCl_zxy: tempC = (REAL4){c.z, c.x, c.y, c.w}; break;
				case multi_OrderOfXYZCl_zyx: tempC = (REAL4){c.z, c.y, c.x, c.w}; break;
			}
		}
		z += tempC * fractal->transformCommon.constantMultiplier111;
	}
	if (fractal->transformCommon.functionEnabled
			&& aux->i >= fractal->transformCommon.startIterationsM
			&& aux->i < fractal->transformCommon.stopIterationsM)
	{
		int count = fractal->transformCommon.int1; // Menger Sponge
		int k;
		for (k = 0; k < count; k++)
		{
			z = fabs(z);
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
			z *= fractal->transformCommon.scale3;
			z.x -= 2.0f * fractal->transformCommon.constantMultiplierA111.x;
			z.y -= 2.0f * fractal->transformCommon.constantMultiplierA111.y;
			if (z.z > 1.0f) z.z -= 2.0f * fractal->transformCommon.constantMultiplierA111.z;
			aux->DE *= fabs(fractal->transformCommon.scale3 * fractal->transformCommon.scaleA1);

			z += fractal->transformCommon.additionConstantA000;

			if (fractal->transformCommon.functionEnabledxFalse) // addCpixel options
			{
				switch (fractal->mandelbulbMulti.orderOfXYZC)
				{
					case multi_OrderOfXYZCl_xyz:
					default: c = (REAL4){c.x, c.y, c.z, c.w}; break;
					case multi_OrderOfXYZCl_xzy: c = (REAL4){c.x, c.z, c.y, c.w}; break;
					case multi_OrderOfXYZCl_yxz: c = (REAL4){c.y, c.x, c.z, c.w}; break;
					case multi_OrderOfXYZCl_yzx: c = (REAL4){c.y, c.z, c.x, c.w}; break;
					case multi_OrderOfXYZCl_zxy: c = (REAL4){c.z, c.x, c.y, c.w}; break;
					case multi_OrderOfXYZCl_zyx: c = (REAL4){c.z, c.y, c.x, c.w}; break;
				}
				z += c * fractal->transformCommon.constantMultiplierB111;
			}
		}
	}
	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;

	aux->color += colorAdd;
	return z;
}