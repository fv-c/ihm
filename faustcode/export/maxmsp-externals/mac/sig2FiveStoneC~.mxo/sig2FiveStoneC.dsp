declare name "sig2FiveStoneC";
declare author "Francesco Vitucci";
declare version "1.0";

import("ST.lib");
import("tools.lib");
import("vecOp.lib");

//=============================SPAZIALIZZATORE=======================================
//===================================================================================

// stAzOff è applicato al fronte relativo di stone.
// se stAzOff è positivo, stone è ruotato in senso antiorario e viceversa.
sig2StoneC(sig,stX,stY,stZ,stAzOff,sigX,sigY,sigZ) =    sig*ba.db2linear(-abtdB) ://sig*ba.db2linear(insp(-abtdB)) : 
                                                        de.delay(ma.SR,pm.l2s(distSigSt)) ://de.delay(ma.SR,pm.l2s(distinsp(distSigSt))) : 
                                                        mto1ox(sigStAz+stAzOff,sigStEl) ://mto1ox(azinsp(sigStAz)+stAzOff,sigStEl) :  
                                                        bamodulex
with {
    stXYZ = (stX,stY,stZ);
    stXY = (stX,stY);
    stXZ = (stX,stZ);
    sigXYZ = (sigX,sigY,sigZ);
    vtXYZ = subV(stXYZ,sigXYZ); // vettore di differenza
    vtX = ba.take(1,vtXYZ);
    vtY = ba.take(2,vtXYZ);
    vtZ = ba.take(3,vtXYZ);
    vtXY = (vtX,vtY);
    vtXZ = (vtX,vtZ);
    distSigSt = sqrt((sigX-stX)^2+(sigY-stY)^2+(sigZ-stZ)^2);
    abtdB = 11*log10(max(distSigSt,1));
    //amp = 1/((1+distSigSt)^2);
    sigStAz = select2(sigX*stY - sigY*stX < 0,1,-1) * vecAng(normVec(stXY),normVec(subV((0,0),vtXY)));
    sigStEl = select2(sigX*stZ - sigZ*stX < 0,-1,1) * (vecAng(normVec(stXZ),normVec(subV((0,0),vtXZ))));
};

//===================================================================================
//===================================================================================

insp(dB) = attach(dB,dB : vbargraph("attenuation[style:numerical]",-70,0));
distinsp(d) = attach(d,d : vbargraph("distance[style:numerical]",0,13));
azinsp(az) = attach(az,az : vbargraph("azimuth[style:numerical]",0-ma.PI,ma.PI));

//process = insp(-50);

stone1X = 7.3;
stone1Y = -6.7;
stone1Z = 0;
stone1AzimuthOffset = 0;

stone2X = 9.3;
stone2Y = -3.6;
stone2Z = 0;
stone2AzimuthOffset = 0;

stone3X = 10;
stone3Y = 0;
stone3Z = 0;
stone3AzimuthOffset = 0;

stone4X = 9.3;
stone4Y = 3.6;
stone4Z = 0;
stone4AzimuthOffset = 0;

stone5X = 7.3;
stone5Y = 6.7;
stone5Z = 0;
stone5AzimuthOffset = 0;

sigX = hslider("sigX",11,1,15,0.001) : si.smoo;
sigY = hslider("sigY",0,-8,8,0.001) : si.smoo;
sigZ = hslider("sigZ",0,-16,16,0.001) : si.smoo;

sig2FiveStoneC = _ <:   sig2StoneC(_,stone1X,stone1Y,stone1Z,stone1AzimuthOffset,sigX,sigY,sigZ),
                        sig2StoneC(_,stone2X,stone2Y,stone2Z,stone2AzimuthOffset,sigX,sigY,sigZ),
                        sig2StoneC(_,stone3X,stone3Y,stone3Z,stone3AzimuthOffset,sigX,sigY,sigZ),
                        sig2StoneC(_,stone4X,stone4Y,stone4Z,stone4AzimuthOffset,sigX,sigY,sigZ),
                        sig2StoneC(_,stone5X,stone5Y,stone5Z,stone5AzimuthOffset,sigX,sigY,sigZ);

process = sig2FiveStoneC;