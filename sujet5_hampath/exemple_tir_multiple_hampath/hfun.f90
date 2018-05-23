!!********************************************************************
!>  \ingroup problemDefinition
!!  \brief True Hamiltonian.
!!  \param[in] t      Time
!!  \param[in] n      State dimension
!!  \param[in] z      State and adjoint state at t
!!  \param[in] iarc   Index of the current arc
!!  \param[in] npar   Number of optional parameters
!!  \param[in] par    Optional parameters
!!
!!  \param[out] h   True Hamiltonian
!!  \attention      The vector par can be used for
!!                    constant values or homotopic parameters.
!!!
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2009-2015
!!  \copyright Eclipse Public License
    Subroutine hfun(t,n,z,iarc,npar,par,h)
        implicit none
        integer, intent(in)                             :: n,npar,iarc
        double precision, intent(in)                    :: t
        double precision, dimension(2*n),  intent(in)   :: z
        double precision, dimension(npar), intent(in)   :: par
        double precision, intent(out)                   :: h

        external printandstop

        !Local variables
        double precision :: x,v,px,pv,lambda,u

        IF (n.NE.2) THEN
            call printandstop('Error: wrong state dimension.')
        END IF
        IF (npar.NE.6) THEN
            call printandstop('Error: wrong par dimension.')
        END IF

        !Problem definition
        !min tf
        !
        !dot x = v
        !dot v = -lambda v**2 + u
        lambda  = par(6)
        x       = z(1)
        v       = z(2)
        px      = z(n+1)
        pv      = z(n+2)

        call control(t,n,z,iarc,npar,par,u)

        h = px * v + pv * (-lambda*v**2 + u)

    end subroutine hfun
