! test-la.f90
! Mac Radigan

  program test_la

    use dispmodule

    implicit none

    type(disp_settings) ds
    real start, finish, tarray(2)

    integer, parameter                      :: dim1 = 5
    integer, parameter                      :: dim2 = 5
    integer, parameter                      :: dim3 = 5
    double precision, dimension(dim1, dim2) :: A
    double precision, dimension(dim2, dim3) :: B
    double precision, dimension(dim1, dim3) :: C
    double precision                        :: alpha = 1.0d0
    double precision                        :: beta  = 0.0d0
    character*1, parameter                  :: CR = char(13)

    call srand(8675309)
    call random_number(A)
    call random_number(B)
 
    call etime(tarray, start)
    call dgemm('N', 'N', dim1, dim3, dim2, alpha, A, dim1, B, dim2, beta, C, dim1)
    call etime(tarray, finish)

    ds = disp_get()
    call disp_set_factory
    call disp_set(digmax=5)
    call disp_set(style='-pad')
    call disp_set(zeroas='*')
    call disp_set(matsep=' | ')

    call disp('[ Matrix A ]', A, advance='no')
    call disp('[ Matrix B ]', B, advance='no')
    call disp('[ Matrix C ]', C, advance='double')

    print *,'elaped time ',finish - start,' s'

  end program test_la
