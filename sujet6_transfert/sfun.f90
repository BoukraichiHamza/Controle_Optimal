!!********************************************************************
!>  \ingroup problemDefinition
!!  \brief Shooting function.
!!  \param[in] ny       Shooting variable dimension
!!  \param[in] y        Shooting variable
!!  \param[in] npar     Number of optional parameters
!!  \param[in] par      Optional parameters
!!
!!  \param[out] s       Shooting value, same dimension as y
!!  \attention          The vector par can be used for constant values
!!                      or homotopic parameters.
!!
!!  \author BOUKRAICHI Hamza (INP-ENSEEIHT)
!!  \date   2018

    Subroutine sfun(ny,y,npar,par,s)
        use mod_exphv4sfun
        implicit none
        integer, intent(in)                             :: ny
        integer, intent(in)                             :: npar
        double precision,  dimension(ny),   intent(in)  :: y
        double precision,  dimension(npar), intent(in)  :: par
        double precision,  dimension(ny),   intent(out) :: s

        external printandstop

        !!  The user can call hfun and exphv subroutines inside sfun
        !!
        !!  hfun: code the true Hamiltonian
        !!
        !!      syntax: call hfun(t,n,z,iarc,npar,par,h)
        !!
        !!      see hfun.f90 for details.
        !!
        !!  exphv: computes the chronological exponential of the
        !!          Hamiltonian vector field hv defined by h.
        !!
        !!      syntax: call exphv(tspan,n,z0,iarc,npar,par,zf)
        !!
        !!       integer         , intent(in)    :: n
        !!       integer         , intent(in)    :: iarc
        !!       integer         , intent(in)    :: npar
        !!       double precision, intent(in)    :: tspan(:) = [t0 ... tf]
        !!       double precision, intent(in)    :: z0(2*n)
        !!       double precision, intent(in)    :: par(npar)
        !!       double precision, intent(out)   :: zf(2*n) = z(tf)
        !!

        !Local variables
        double precision :: t0,t1,tf,z0(8),expz0(8),tspan(2),hf,mu,rf,a
        integer          :: n,iarc

        IF (ny.NE.5) THEN
            call printandstop('Error: wrong shooting variable dimension.')
        END IF
        IF (npar.NE.8) THEN
            call printandstop('Error: wrong par dimension.')
        END IF
        iarc    = 1 ! Il n'y a qu'un seul arc
        n       = 4
        t0      = par(1)
        tf      = y(5)
        mu      = par(6)
        rf      = par(7) 
        a = sqrt(mu/(rf**3))

        z0(1:n) = par(2:5)          
        z0(n+1:2*n) = y(1:4)      

        ! Integration 
        tspan   = (/t0, tf/)
        call exphv(tspan,n,z0,iarc,npar,par,expz0)


        call hfun(tf,n,expz0,iarc,npar,par,hf)

        s(2)    = expz0(3) +  a*expz0(2) 
        s(3)    = expz0(4) -  a*expz0(1)  
        s(1)    =  sqrt(expz0(1)**2 + expz0(2)**2) - rf        
        s(4)    = expz0(2)*(expz0(5)+a*expz0(8))-expz0(1)*(expz0(6)-a*expz0(7))
        s(5)    = hf - 1d0         

    end subroutine sfun
