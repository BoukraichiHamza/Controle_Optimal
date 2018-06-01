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
        

        !Local variables
        double precision :: t0,t1,tf,z0(2),z1(2),expz0(2),expz1(2),tspan(2),xf,hf
        integer          :: n,iarc

        IF (ny.NE.4) THEN
            call printandstop('Error: wrong shooting variable dimension.')
        END IF
        IF (npar.NE.4) THEN
            call printandstop('Error: wrong par dimension.')
        END IF

        n       = 1
        t0      = par(1)
        xf      = par(4)
        tf      = par(2)

        z0( 1) = par(3)             ! x0
        z0( 2) = y(1)             ! v0
        t1 = y(2)              ! px0
        z1 = y(3:4)              ! pv0

        ! Integration on the first arc: u = +1
        iarc    = 1
        tspan   = (/t0, t1/)
        call exphv(tspan,n,z0,iarc,npar,par,expz0)

        ! Integration on the second arc: u = -1
        iarc    = 2
        tspan   = (/t1, tf/)
        call exphv(tspan,n,z1,iarc,npar,par,expz1)

        call hfun(tf,n,expz1,iarc,npar,par,hf)

        s(1)    = expz1(1) - xf ! Final condition on xf
        s(2)    = abs(expz0(2))-1          ! Switching conditions
        s(3:4)  = z1 - expz0        ! Matching condition z1 = z(t1)
        

    end subroutine sfun
