function gfortranMatlab(cas)

global MATLAB_LD_LIBRARY_PATH

if(nargin==0)
  error('Wrong syntax!');
end;

if(cas==1)

setenv('GFORTRAN_STDIN_UNIT','5');
setenv('GFORTRAN_STDOUT_UNIT','6');
setenv('GFORTRAN_STDERR_UNIT','0');
%
% Library du au message
MATLAB_LD_LIBRARY_PATH = getenv('LD_LIBRARY_PATH');
HAMPATH_LD_LIBRARY_PATH = ['/usr/lib/x86_64-linux-gnu:' MATLAB_LD_LIBRARY_PATH];
setenv('LD_LIBRARY_PATH', HAMPATH_LD_LIBRARY_PATH);

else

setenv('GFORTRAN_STDIN_UNIT','-1');
setenv('GFORTRAN_STDOUT_UNIT','-1');
setenv('GFORTRAN_STDERR_UNIT','-1');

setenv('LD_LIBRARY_PATH', MATLAB_LD_LIBRARY_PATH)

end;

return
