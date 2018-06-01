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
!!  \author BOUKRAICHI Hamza (INP-ENSEEIHT)
!!  \date   2018

    Subroutine hfun(t,n,z,iarc,npar,par,h)
        implicit none
        integer, intent(in)                             :: n,npar,iarc
        double precision, intent(in)                    :: t
        double precision, dimension(2*n),  intent(in)   :: z
        double precision, dimension(npar), intent(in)   :: par
        double precision, intent(out)                   :: h

        external printandstop

        !Local variables
        double precision :: x(n),p(n),mu,rad,u(2)

        IF (n.NE.4) THEN
            call printandstop('Error: wrong state dimension.')
        END IF
        IF (npar.NE.8) THEN
            call printandstop('Error: wrong par dimension.')
        END IF
        ! par = [t0 x0  mu rf gamma_m]
        
        x = z(1:n)
        p = z(n+1:2*n)


        call control(t,n,z,iarc,npar,par,u)
        mu = par(6)
        rad = sqrt(x(1)**2+x(2)**2)
        h = p(1)*x(3)
        h = h  + p(2)*x(4) 
        h = h + p(3)* (-(mu*x(1))/rad**(3) + u(1)) 
        h = h + p(4)*(-(mu*x(2))/rad**3 + u(2))


    end subroutine hfun
