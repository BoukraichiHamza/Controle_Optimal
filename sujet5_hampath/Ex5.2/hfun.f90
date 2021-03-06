!!********************************************************************
!>  \ingroup problemDefinition
!!  \brief True Hamiltonian.
!!  \param[in] t    Time
!!  \param[in] n    State dimension
!!  \param[in] z    State and adjoint state at t
!!  \param[in] iarc Index of the current arc
!!  \param[in] npar Number of optional parameters
!!  \param[in] par  Optional parameters
!!
!!  \param[out] h   True Hamiltonian
!!  \attention      The vector par can be used for
!!                  constant values or homotopic parameters.
!!!
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2009-2016
!!  \copyright Eclipse Public License
    Subroutine hfun(t,n,z,iarc,npar,par,h)
        implicit none
        integer,                           intent(in)  :: n,npar,iarc
        double precision,                  intent(in)  :: t
        double precision, dimension(2*n),  intent(in)  :: z
        double precision, dimension(npar), intent(in)  :: par
        double precision,                  intent(out) :: h
        double precision :: p,eps

        external printandstop

        !Local declaration
        double precision :: x,u

        IF (n.NE.1) THEN
            call printandstop('Error: wrong state dimension.')
        END IF
        IF (npar.NE.5) THEN
            call printandstop('Error: wrong par dimension.')
        END IF

        x  = z(1)
        p  = z(2)
        eps = par(5)
        call control(t,n,z,iarc,npar,par,u)
        h = p*(-x+u) -(abs(u)-eps*(log(abs(u))+log(1-abs(u))))

    end subroutine hfun
