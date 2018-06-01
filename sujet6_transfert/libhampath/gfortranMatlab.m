function gfortranMatlab(cas)

if(nargin==0)
    error('Wrong syntax!');
end;

if(cas==1)

setenv('GFORTRAN_STDIN_UNIT','5');
setenv('GFORTRAN_STDOUT_UNIT','6');
setenv('GFORTRAN_STDERR_UNIT','0');

else

setenv('GFORTRAN_STDIN_UNIT','-1');
setenv('GFORTRAN_STDOUT_UNIT','-1');
setenv('GFORTRAN_STDERR_UNIT','-1');

end;

return
