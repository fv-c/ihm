declare filename "msdec4chR.dsp";
declare name "msdec4chR";
declare author "Francesco Vitucci";

import("stdfaust.lib");

msdec(N,m,s) = m,s <: par(i,N,lspk((i*2*ma.PI/N)+(ma.PI/N)))
  with {
    lspk(a) = m*cos(a)+s*sin(a);
  };

process = msdec(4,_,_);