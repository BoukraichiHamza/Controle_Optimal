!!********************************************************************
!>  \ingroup problemDefinition
!!  \brief Optimal control.
!!  \param[in] t    Time
!!  \param[in] n    State dimension
!!  \param[in] z    State and adjoint state at t
!!  \param[in] iarc Index of the current arc
!!  \param[in] npar Number of optional parameters
!!  \param[in] par  Optional parameters
!!
!!  \param[out] u   Optimal control
!!  \attention      The vector par can be used for
!!                  constant values or homotopic parameters.
!!!
!!  \author BOUKRAICHI Hamza (INP-ENSEEIHT)
!!  \date   2018

    Subroutine control(t,n,z,iarc,npar,par,u)
        implicit none
        integer, intent(in)                             :: n,npar,iarc
        double precision, intent(in)                    :: t
        double precision, dimension(2*n),  intent(in)   :: z
        double precision, dimension(npar), intent(in)   :: par
        double precision, dimension(2),intent(out)      :: u
        double precision :: p3,p4,norm34,gamma_m

        IF (n.NE.4) THEN
            call printandstop('Error: wrong state dimension.')
        END IF
        IF (npar.NE.8) THEN
            call printandstop('Error: wrong par dimension.')
        END IF

        p3  = z(n+3)
        p4  = z(n+4)

        ! par = [t0 x0 mu rf gamma_m]
        gamma_m = par(8)
        norm34 = sqrt(p3**2+p4**2)
        u(1) = (gamma_m*p3)/norm34
        u(2) = (gamma_m*p4)/norm34

    end subroutine control
