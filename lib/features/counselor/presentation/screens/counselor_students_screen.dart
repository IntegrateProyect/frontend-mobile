import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import '../providers/counselor_provider.dart';
import '../../../student/domain/entities/student_profile_entity.dart';

class CounselorStudentsScreen extends StatefulWidget {
  const CounselorStudentsScreen({super.key});

  @override
  State<CounselorStudentsScreen> createState() => _CounselorStudentsScreenState();
}

class _CounselorStudentsScreenState extends State<CounselorStudentsScreen> {
  static const Color _primary = Color(0xFF311B92);
  static const Color _darkText = Color(0xFF1D1B4B);
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CounselorProvider>().loadDashboardData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();
    
    final students = provider.students.where((s) {
      final query = _searchQuery.trim().toLowerCase();
      if (query.isEmpty) return true;
      return s.name.toLowerCase().contains(query) || 
             s.email.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _darkText),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Mis Alumnos',
          style: TextStyle(
            color: _darkText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
            child: _buildSearchField(),
          ),
          Expanded(
            child: provider.isLoading && provider.students.isEmpty
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : students.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => provider.loadDashboardData(),
                        color: _primary,
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                          itemCount: students.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            return _buildStudentCard(students[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o correo',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 64.sp, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text(
            'No se encontraron alumnos',
            style: TextStyle(color: _darkText, fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentProfileEntity student) {
    final String initial = student.name.isNotEmpty ? student.name[0].toUpperCase() : '?';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () {
          context.push(
            AppRoutes.studentFile.path,
            extra: {
              'studentId': student.id,
              'studentName': student.name,
            },
          );
        },
        child: Ink(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFEDEEF4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: _primary.withOpacity(0.1),
                child: Text(
                  initial,
                  style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: TextStyle(color: _darkText, fontWeight: FontWeight.bold, fontSize: 15.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      student.email,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.push(
                    AppRoutes.realChat.path,
                    extra: {
                      'contactId': student.id,
                      'contactName': student.name,
                    },
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: _primary),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
