! l1ca.f90
! Mac Radigan

  module l1ca

    use iso_c_binding
    implicit none
    public  :: lfsr, lfsr_init, & 
               reg_init, reg_final, codebook, &
               FREQUENCY, N_CODES
    private :: poly
    
    integer :: poly = o'624145772'
    integer(c_int), parameter :: N_CODES = 210
    integer(c_int), parameter :: CODE_LENGTH = 1023
    real(c_double), parameter :: FREQUENCY = 1.023e6 ! chipping rate [Hz]

    integer(c_int), parameter :: N1 = 2
    integer(c_int), parameter :: N2 = 3
    
    integer(c_int), allocatable, dimension(:,:), save :: codebook
    
    integer(c_int), dimension(N_CODES) :: reg_init
    data reg_init /                                                            &
          5,   6,   7,   8,  17,  18, 139, 140, 141, 251, 252, 254,  255, 256, &
        257, 258, 469, 470, 471, 472, 473, 474, 509, 512, 513, 514,  515, 516, &
        859, 860, 861, 862,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0, &
          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,    0,   0, &
          0,   0,   0,   0,   0,   0,   0, 729, 695, 780, 801, 788,  732,  34, &
        320, 327, 389, 407, 525, 405, 221, 761, 260, 326, 955, 653,  699, 422, &
        188, 438, 959, 539, 879, 677, 586, 153, 792, 814, 446, 264, 1015, 278, &
        536, 819, 156, 957, 159, 712, 885, 461, 248, 713, 126, 807,  279, 122, &
        197, 693, 632, 771, 467, 647, 203, 145, 175,  52,  21, 237,  235, 886, &
        657, 634, 762, 355,1012, 176, 603, 130, 359, 595,  68, 386,  797, 456, &
        499, 883, 307, 127, 211, 121, 118, 163, 628, 853, 484, 289,  811, 202, &
       1021, 463, 568, 904, 670, 230, 911, 684, 309, 644, 932,  12,  314, 891, &
        212, 185, 675, 503, 150, 395, 345, 846, 798, 992, 357, 995,  877, 112, &
        144, 476, 193, 109, 445, 291,  87, 399, 292, 901, 339, 208,  711, 189, &
        263, 537, 663, 942, 173, 900,  30, 500, 935, 556, 373,  85,  652, 310  &
    /
 
    integer(c_int), dimension(N_CODES) :: reg_final
    data reg_final /                                                          &
      1440, 1620, 1710, 1744, 1133, 1455, 1131, 1454, 1626, 1504, 1642, 1750, &
      1764, 1772, 1775, 1776, 1156, 1467, 1633, 1715, 1746, 1763, 1063, 1706, &
      1743, 1761, 1770, 1774, 1127, 1453, 1625, 1712, 1745, 1713, 1134, 1456, &
      1713, 1517,  322,  242, 1031,  744,  564, 1067, 1056,   14,   26, 1342, &
      1006, 1637, 1666, 1121,  761, 1315,  766, 1225, 1732,  673, 1220, 1413, &
       671,  536, 1510, 1545,  160,  701, 1523,  175,  617,  663,  435, 1752, &
       245,  731, 1373,  332,  723, 1705, 1515, 1700, 1256,  377,  767,  336, &
      1412, 1507, 1514, 1164, 1500,  215,  103,  664,  532, 1171, 1641, 1521, &
       227,  543, 1517,  322,  242, 1031,  744,  564, 1067, 1056,   14,   26, &
      1342, 1042, 1006, 1637, 1666, 1121,  761, 1315,  766, 1225, 1732,  673, &
      1220, 1413,  671,  536, 1510, 1545,  160,  710,   13, 1060,  245,  527, &
      1436, 1226, 1257,   46, 1071,  561, 1037,  770, 1327, 1472,  124,  366, &
       133,  465,  717,  217, 1742, 1422, 1442,  523,  736, 1635,  136,  273, &
      1026,    3,  554,   75, 1341,   42,  115,  207,  204, 1576, 1142,   40, &
       107, 1643,  553,  317,  415,  123, 1267, 1535,  635,  760,  707, 1276, &
      1322,  211, 1562,  774,  323,  112, 1306,   27, 1470, 1505, 1013,  355, &
       727,  170,   30,  472, 1237,  414, 1050, 1630,  571,  732, 1301, 1173, &
        20,  447, 1114,  341, 1024, 1046                                      &
    /

  contains

    recursive function lfsr(reg, k) result(new_reg) bind(c, name="l1ca_lfsr") 
      
      integer(c_int), intent(in) :: reg
      integer(c_int), intent(in) :: k
      integer(c_int)             :: new_reg ! result
      integer                    :: it
      new_reg = reg
      do it = 1, k, 1
        new_reg = ieor(new_reg, poly)
        new_reg = ishft(new_reg, 1)
      end do
      
    end function lfsr

    subroutine lfsr_init() bind(c, name="l1ca_init")
      integer                    :: m
      integer                    :: n
      allocate(codebook(N_CODES,CODE_LENGTH))
      return
    end subroutine lfsr_init

  end module l1ca

! *EOF*
