import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

import '../../../student/domain/entities/student_profile_entity.dart';
import '../providers/counselor_provider.dart';

class GroupStudentsScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupStudentsScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupStudentsScreen> createState() {
    return _GroupStudentsScreenState();
  }
}

class _GroupStudentsScreenState
    extends State<GroupStudentsScreen> {
  static const Color _primaryColor =
  Color(0xFF311B92);

  static const Color _darkText =
  Color(0xFF1D1B4B);

  List<StudentProfileEntity> _groupStudents = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStudents();
    });
  }

  Future<void> _loadStudents() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final provider =
      context.read<CounselorProvider>();

      final students =
      await provider.getGroupStudents(
        widget.groupId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _groupStudents = students;
        _loading = false;
      });
    } catch (error) {
      debugPrint(
        'ERROR CARGANDO ALUMNOS DEL GRUPO: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _groupStudents = [];
        _error = error
            .toString()
            .replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          tooltip: 'Regresar',
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              widget.groupName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),
            ),
            Text(
              _loading
                  ? 'Cargando alumnos...'
                  : '${_groupStudents.length} '
                  '${_groupStudents.length == 1 ? 'alumno registrado' : 'alumnos registrados'}',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: _primaryColor,
        ),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_groupStudents.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: _primaryColor,
      onRefresh: _loadStudents,
      child: ListView.separated(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          20.w,
          20.h,
          20.w,
          32.h,
        ),
        itemCount: _groupStudents.length,
        separatorBuilder: (_, __) {
          return SizedBox(height: 14.h);
        },
        itemBuilder: (context, index) {
          return _buildStudentCard(
            _groupStudents[index],
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 76.w,
              height: 76.w,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 38.sp,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'No fue posible cargar los alumnos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: _darkText,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _error ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            SizedBox(height: 22.h),
            ElevatedButton.icon(
              onPressed: _loadStudents,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 13.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14.r),
                ),
              ),
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Intentar nuevamente',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: _primaryColor,
      onRefresh: _loadStudents,
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(24.w),
        children: [
          SizedBox(height: 150.h),
          Icon(
            Icons.group_off_outlined,
            size: 68.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            'No hay alumnos en este grupo',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _darkText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'Comparte el código del grupo para que '
                'los estudiantes puedan unirse.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(
      StudentProfileEntity student,
      ) {
    final String cleanName =
    student.name.trim().isNotEmpty
        ? student.name.trim()
        : 'Alumno sin nombre';

    final String cleanEmail =
    student.email.trim().isNotEmpty
        ? student.email.trim()
        : 'Correo no disponible';

    final String initial = cleanName
        .substring(0, 1)
        .toUpperCase();

    final String? imageUrl =
    student.profileImageUrl?.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: student.id.trim().isEmpty
            ? null
            : () {
          context.push(
            AppRoutes.studentFile.path,
            extra: {
              'studentId': student.id,
              'studentName': cleanName,
            },
          );
        },
        child: Ink(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFFEDEEF4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 12,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor:
                _primaryColor.withOpacity(0.10),
                backgroundImage: imageUrl != null &&
                    imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl == null ||
                    imageUrl.isEmpty
                    ? Text(
                  initial,
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                )
                    : null,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      cleanName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 14.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            cleanEmail,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                              Colors.grey.shade600,
                              fontSize: 11.5.sp,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color:
                  _primaryColor.withOpacity(0.08),
                  borderRadius:
                  BorderRadius.circular(13.r),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: _primaryColor,
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}