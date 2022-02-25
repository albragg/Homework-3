//
//  Overlap Integral Equations.swift
//  Monte Carlo Integration (iOS)
//
//  Created by Alyssa Bragg on 2/17/22.
//

import Foundation

func psi1S(r: Double, a0: Double)-> Double{
    let psi = 1.0 / (sqrt(Double.pi)*pow(a0, 3/2)) * exp(-r/a0) // symmetric around theta, phi
    return psi
}

func psi2PX(r: Double, a0: Double, theta: Double, phi: Double) -> Double{
    let psi = 1.0 / (4.0*sqrt(2.0*Double.pi)*pow(a0, 3/2)) * r/a0 * exp(-r/(2*a0))*sin(theta)*cos(phi)
    return psi
}

func analyticalOverlapIntPsi1SPsi1S(r: Double, a0: Double) -> Double {
    let ans = exp(-r/a0) * (1+r/a0+pow(r, 2)/(3*pow(a0, 2)))
    return ans
}
