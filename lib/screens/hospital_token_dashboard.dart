import 'dart:async';

import 'package:flutter/material.dart';

class Clinic {
  final String name;
  final String doctor;
  final String token;
  final bool isActive;

  const Clinic({
    required this.name,
    required this.doctor,
    required this.token,
    this.isActive = true,
  });
}

class Department {
  final String name;
  final List<Clinic> clinics;

  const Department({required this.name, required this.clinics});
}

class HospitalTokenDashboard extends StatefulWidget {
  final List<Department> departments;

  const HospitalTokenDashboard({super.key, required this.departments});

  @override
  State<HospitalTokenDashboard> createState() => _HospitalTokenDashboardState();
}

class _HospitalTokenDashboardState extends State<HospitalTokenDashboard> {
  final PageController _pageController = PageController();

  Timer? _pageTimer;

  int _currentPage = 0;

  List<TokenPage> _pages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _restartPageTimer() {
    _pageTimer?.cancel();

    if (_pages.length <= 1) {
      return;
    }

    _pageTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      final nextPage = (_currentPage + 1) % _pages.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );

      _currentPage = nextPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            final layout = _calculateLayout(screenWidth, screenHeight);

            _pages = _createPages(
              widget.departments,
              layout.columns,
              layout.rowsPerDepartment,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _restartPageTimer();
              }
            });

            if (_pages.isEmpty) {
              return const Center(
                child: Text(
                  'No Token Information Available',
                  style: TextStyle(fontSize: 32),
                ),
              );
            }

            return Column(
              children: [
                // HEADER
                SizedBox(
                  height: layout.headerHeight,
                  child: _buildHeader(layout),
                ),

                // MAIN CONTENT
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      if (!mounted) return;

                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildTokenPage(_pages[index], layout);
                    },
                  ),
                ),

                // FOOTER
                SizedBox(
                  height: layout.footerHeight,
                  child: _buildFooter(layout),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // RESPONSIVE LAYOUT
  // ----------------------------------------------------------

  TokenLayout _calculateLayout(double width, double height) {
    // 16:9 TV
    //
    // 4K:
    // 3840 x 2160
    //
    // Full HD:
    // 1920 x 1080

    int columns;

    if (width >= 3000) {
      columns = 3;
    } else if (width >= 1800) {
      columns = 2;
    } else {
      columns = 1;
    }

    // Available height after header/footer.
    //
    // We want approximately 8 clinics on a 4K / FHD screen.

    const headerRatio = 0.075;
    const footerRatio = 0.055;

    final headerHeight = height * headerRatio;
    final footerHeight = height * footerRatio;

    final contentHeight = height - headerHeight - footerHeight;

    // Header of each department
    final departmentHeaderHeight = height >= 1800 ? 80.0 : 55.0;

    // Approximate clinic row height.
    final clinicHeight = height >= 1800 ? 92.0 : 65.0;

    final usableClinicHeight = contentHeight - departmentHeaderHeight;

    int rows = (usableClinicHeight / clinicHeight).floor();

    // Minimum / maximum protection
    rows = rows.clamp(4, 10);

    return TokenLayout(
      columns: columns,
      rowsPerDepartment: rows,
      headerHeight: headerHeight,
      footerHeight: footerHeight,
      departmentHeaderHeight: departmentHeaderHeight,
      clinicHeight: clinicHeight,
    );
  }

  // ----------------------------------------------------------
  // CREATE PAGES
  // ----------------------------------------------------------

  List<TokenPage> _createPages(
    List<Department> departments,
    int columns,
    int rowsPerDepartment,
  ) {
    if (departments.isEmpty) {
      return [];
    }

    final List<TokenPage> result = [];

    // Split departments into groups according to
    // number of columns available on the TV.

    for (
      int departmentStart = 0;
      departmentStart < departments.length;
      departmentStart += columns
    ) {
      final departmentGroup = departments
          .skip(departmentStart)
          .take(columns)
          .toList();

      // Find the department which has the maximum
      // number of clinic pages.

      int maxClinicPages = 1;

      for (final department in departmentGroup) {
        final clinicPages = (department.clinics.length / rowsPerDepartment)
            .ceil();

        if (clinicPages > maxClinicPages) {
          maxClinicPages = clinicPages;
        }
      }

      // Create clinic pages for this department group.

      for (int clinicPage = 0; clinicPage < maxClinicPages; clinicPage++) {
        final List<DepartmentPageData> pageDepartments = [];

        for (final department in departmentGroup) {
          final start = clinicPage * rowsPerDepartment;

          final end = (start + rowsPerDepartment).clamp(
            0,
            department.clinics.length,
          );

          final clinics = start < department.clinics.length
              ? department.clinics.sublist(start, end)
              : <Clinic>[];

          pageDepartments.add(
            DepartmentPageData(department: department, clinics: clinics),
          );
        }

        result.add(TokenPage(departments: pageDepartments));
      }
    }

    return result;
  }

  // ----------------------------------------------------------
  // TOKEN PAGE
  // ----------------------------------------------------------

  Widget _buildTokenPage(TokenPage page, TokenLayout layout) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: layout.horizontalPadding,
        vertical: layout.verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(page.departments.length, (index) {
          final department = page.departments[index];

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: layout.columnSpacing / 2,
              ),
              child: _buildDepartment(department, layout),
            ),
          );
        }),
      ),
    );
  }

  // ----------------------------------------------------------
  // DEPARTMENT
  // ----------------------------------------------------------

  Widget _buildDepartment(DepartmentPageData data, TokenLayout layout) {
    return Column(
      children: [
        // DEPARTMENT HEADER
        Container(
          height: layout.departmentHeaderHeight,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Text(
            data.department.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: layout.departmentFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // CLINICS
        Expanded(
          child: Column(
            children: List.generate(layout.rowsPerDepartment, (index) {
              if (index >= data.clinics.length) {
                return Expanded(child: const SizedBox());
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _buildClinic(data.clinics[index], layout),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // CLINIC
  // ----------------------------------------------------------

  Widget _buildClinic(Clinic clinic, TokenLayout layout) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // PLUS ICON
          SizedBox(
            width: layout.iconWidth,
            child: Center(
              child: Container(
                width: layout.iconSize,
                height: layout.iconSize,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: layout.iconSize * 0.75,
                ),
              ),
            ),
          ),

          // CLINIC NAME
          Expanded(
            flex: 2,
            child: Text(
              clinic.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: layout.clinicFontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF173B64),
              ),
            ),
          ),

          // DOCTOR
          Expanded(
            flex: 3,
            child: Text(
              clinic.doctor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: layout.doctorFontSize,
                color: const Color(0xFF536773),
              ),
            ),
          ),

          // TOKEN
          Container(
            width: layout.tokenWidth,
            height: layout.tokenHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green.shade700, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              clinic.token,
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: layout.tokenFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // STATUS
          SizedBox(
            width: layout.statusWidth,
            child: Center(
              child: Container(
                width: layout.statusSize,
                height: layout.statusSize,
                decoration: BoxDecoration(
                  color: clinic.isActive ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader(TokenLayout layout) {
    return Container(
      color: const Color(0xFF1268B8),
      padding: EdgeInsets.symmetric(horizontal: layout.headerPadding),
      child: Row(
        children: [
          // LOGO
          Container(
            width: layout.logoSize,
            height: layout.logoSize,
            color: Colors.white,
            child: const Icon(Icons.local_hospital, color: Colors.green),
          ),

          SizedBox(width: layout.headerSpacing),

          // HOSPITAL NAME
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KALYANI HOSPITAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: layout.hospitalFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'OPD Token Management System',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: layout.subtitleFontSize,
                  ),
                ),
              ],
            ),
          ),

          // TITLE
          Text(
            'TOKEN DISPLAY',
            style: TextStyle(
              color: Colors.white,
              fontSize: layout.titleFontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),

          const Spacer(),

          // DATE / TIME
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formattedDate(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: layout.timeFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formattedTime(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: layout.timeFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // FOOTER
  // ----------------------------------------------------------

  Widget _buildFooter(TokenLayout layout) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1268B8),
      child: Center(
        child: _pages.length > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPage
                          ? Colors.white
                          : Colors.white38,
                    ),
                  );
                }),
              )
            : const SizedBox(),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();

    return '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';
  }

  String _formattedTime() {
    final now = DateTime.now();

    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;

    final period = now.hour >= 12 ? 'PM' : 'AM';

    return '${hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')} $period';
  }
}

// ==========================================================
// DATA CLASSES
// ==========================================================

class DepartmentPageData {
  final Department department;
  final List<Clinic> clinics;

  const DepartmentPageData({required this.department, required this.clinics});
}

class TokenPage {
  final List<DepartmentPageData> departments;

  const TokenPage({required this.departments});
}

// ==========================================================
// RESPONSIVE LAYOUT
// ==========================================================

class TokenLayout {
  final int columns;
  final int rowsPerDepartment;

  final double headerHeight;
  final double footerHeight;
  final double departmentHeaderHeight;
  final double clinicHeight;

  const TokenLayout({
    required this.columns,
    required this.rowsPerDepartment,
    required this.headerHeight,
    required this.footerHeight,
    required this.departmentHeaderHeight,
    required this.clinicHeight,
  });

  double get horizontalPadding => 20;

  double get verticalPadding => 12;

  double get columnSpacing => 16;

  double get headerPadding => 20;

  double get headerSpacing => 20;

  double get logoSize => headerHeight * 0.72;

  double get hospitalFontSize => headerHeight * 0.27;

  double get subtitleFontSize => headerHeight * 0.15;

  double get titleFontSize => headerHeight * 0.28;

  double get dateFontSize => headerHeight * 0.13;

  double get timeFontSize => headerHeight * 0.20;

  double get departmentFontSize => departmentHeaderHeight * 0.42;

  double get clinicFontSize => clinicHeight * 0.26;

  double get doctorFontSize => clinicHeight * 0.26;

  double get tokenFontSize => clinicHeight * 0.28;

  double get iconSize => clinicHeight * 0.28;

  double get iconWidth => clinicHeight * 0.48;

  double get tokenWidth => clinicHeight * 0.75;

  double get tokenHeight => clinicHeight * 0.58;

  double get statusWidth => clinicHeight * 0.30;

  double get statusSize => clinicHeight * 0.12;
}
