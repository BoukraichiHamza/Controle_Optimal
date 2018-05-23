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
        integer, intent(in)                             :: n,npar,iarc
        double precision, intent(in)                    :: t
        double precision, dimension(2*n),  intent(in)   :: z
        double precision, dimension(npar), intent(in)   :: par
        double precision, intent(out)                   :: u

        IF (n.NE.2) THEN
            call printandstop('Error: wrong state dimension.')
        END IF
        IF (npar.NE.6) THEN
            call printandstop('Error: wrong par dimension.')
        END IF

        if(iarc.eq.1)then
          u = 1d0
        else                ! iarc = 2
          u = -1d0
        end if

    end subroutine control
