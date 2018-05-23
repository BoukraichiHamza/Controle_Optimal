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
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2015-2016
!!  \copyright Eclipse Public License
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
        double precision :: t0,t1,tf,z0(4),z1(4),expz0(4),expz1(4),tspan(2),hf
        integer          :: n,iarc

        IF (ny.NE.8) THEN
            call printandstop('Error: wrong shooting variable dimension.')
        END IF
        IF (npar.NE.6) THEN
            call printandstop('Error: wrong par dimension.')
        END IF

        n       = 2
        t0      = par(1)
        t1      = y(1)
        tf      = y(2)

        z0(  1) = par(2)            ! x0
        z0(  2) = par(3)            ! v0
        z0(n+1) = y(3)              ! px0
        z0(n+2) = y(4)              ! pv0

        z1      = y(5:8)

        ! Integration on the first arc: u = +1
        iarc    = 1
        tspan   = (/t0, t1/)
        call exphv(tspan,n,z0,iarc,npar,par,expz0)

        ! Integration on the second arc: u = -1
        iarc    = 2
        tspan   = (/t1, tf/)
        call exphv(tspan,n,z1,iarc,npar,par,expz1)

        call hfun(tf,n,expz1,iarc,npar,par,hf)

        s(1)    = expz1(1) - par(4) ! Final condition on xf
        s(2)    = expz1(2) - par(5) ! Final condition on vf
        s(3:6)  = z1 - expz0        ! Matching condition z1 = z(t1)
        s(7)    = expz0(n+2)        ! Switching condition pv(t1) = 0
        s(8)    = hf - 1d0          ! Final Hamiltonian condition

    end subroutine sfun
