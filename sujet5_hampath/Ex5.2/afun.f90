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
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2009-2016
!!  \copyright Eclipse Public License
    Subroutine control(t,n,z,iarc,npar,par,u)
        implicit none
        integer,                           intent(in)  :: n,npar,iarc
        double precision,                  intent(in)  :: t
        double precision, dimension(2*n),  intent(in)  :: z
        double precision, dimension(npar), intent(in)  :: par
        double precision,                  intent(out) :: u
        double precision :: x,p,e, psi, signe

        IF (n.NE.1) THEN
            call printandstop('Error: wrong state dimension.')
        END IF
        IF (npar.NE.5) THEN
            call printandstop('Error: wrong par dimension.')
        END IF

        !n  = length(z)/2
        x  = z(1)
        p  = z(2)
        e = par(5)
        signe = 1.0
        psi = abs(p) - 1
        if (p.NE.0) then
                u = -2*e*sign(signe,p)/(psi-2*e - sqrt(psi**2 + 4*e**2))
        else
                u =  -2*e/(-1 -2*e - sqrt(psi**2 + 4*e**2))
        endif
    end subroutine control
