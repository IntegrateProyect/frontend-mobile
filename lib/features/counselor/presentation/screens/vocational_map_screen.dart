import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

// --- MODELOS DE DATOS ---

class StudentPoint {
  final String id; // iniciales del alumno
  final String name; // nombre completo
  final double x; // posición normalizada 0.0 a 1.0
  final double y; // posición normalizada 0.0 a 1.0
  final int clusterId;

  StudentPoint({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.clusterId,
  });
}

class VocationalCluster {
  final int id;
  final String name;
  final String insight;
  final Color color;
  final List<StudentPoint> students;

  VocationalCluster({
    required this.id,
    required this.name,
    required this.insight,
    required this.color,
    required this.students,
  });

  Offset getCentroid() {
    if (students.isEmpty) return Offset.zero;
    double sumX = 0;
    double sumY = 0;
    for (var s in students) {
      sumX += s.x;
      sumY += s.y;
    }
    return Offset(sumX / students.length, sumY / students.length);
  }
}

// --- DATOS DE EJEMPLO (MOCKS) ---

final List<VocationalCluster> sampleClusters = [
  VocationalCluster(
    id: 0,
    name: "Ciencias exactas",
    insight: "El grupo muestra una alta inclinación hacia el razonamiento lógico. Se sugiere organizar una visita al centro de ingeniería.",
    color: const Color(0xFF534AB7),
    students: [
      StudentPoint(id: "AM", name: "Alberto Martínez", x: 0.2, y: 0.2, clusterId: 0),
      StudentPoint(id: "JV", name: "Javier Vargas", x: 0.25, y: 0.15, clusterId: 0),
      StudentPoint(id: "SR", name: "Sofía Rojas", x: 0.15, y: 0.25, clusterId: 0),
      StudentPoint(id: "LG", name: "Luis García", x: 0.3, y: 0.22, clusterId: 0),
      StudentPoint(id: "CP", name: "Carlos Pérez", x: 0.22, y: 0.32, clusterId: 0),
      StudentPoint(id: "MT", name: "María Torres", x: 0.28, y: 0.28, clusterId: 0),
      StudentPoint(id: "RN", name: "Roberto Niño", x: 0.18, y: 0.18, clusterId: 0),
    ],
  ),
  VocationalCluster(
    id: 1,
    name: "Ciencias sociales",
    insight: "Predominan habilidades de comunicación. Recomendado fortalecer el club de debate y oratoria.",
    color: const Color(0xFF0F6E56),
    students: [
      StudentPoint(id: "EL", name: "Elena López", x: 0.75, y: 0.2, clusterId: 1),
      StudentPoint(id: "FP", name: "Fernando Pozos", x: 0.8, y: 0.25, clusterId: 1),
      StudentPoint(id: "GD", name: "Gloria Díaz", x: 0.7, y: 0.15, clusterId: 1),
      StudentPoint(id: "HM", name: "Hugo Morales", x: 0.85, y: 0.18, clusterId: 1),
      StudentPoint(id: "IP", name: "Isabel Peralta", x: 0.78, y: 0.3, clusterId: 1),
      StudentPoint(id: "JC", name: "Juan Castro", x: 0.72, y: 0.28, clusterId: 1),
      StudentPoint(id: "KL", name: "Karla Luna", x: 0.82, y: 0.12, clusterId: 1),
    ],
  ),
  VocationalCluster(
    id: 2,
    name: "Artes y diseño",
    insight: "Alta creatividad visual detectada. Podrían beneficiarse de un taller de portafolios artísticos.",
    color: const Color(0xFFD85A30),
    students: [
      StudentPoint(id: "DA", name: "Diana Arenas", x: 0.25, y: 0.75, clusterId: 2),
      StudentPoint(id: "ES", name: "Eduardo Solís", x: 0.3, y: 0.8, clusterId: 2),
      StudentPoint(id: "FR", name: "Fabiola Ruiz", x: 0.2, y: 0.7, clusterId: 2),
      StudentPoint(id: "GH", name: "Gael Hernández", x: 0.35, y: 0.85, clusterId: 2),
      StudentPoint(id: "IA", name: "Iván Aguilar", x: 0.18, y: 0.78, clusterId: 2),
      StudentPoint(id: "JO", name: "Jimena Ortíz", x: 0.28, y: 0.68, clusterId: 2),
      StudentPoint(id: "LS", name: "Lucía Silva", x: 0.22, y: 0.82, clusterId: 2),
    ],
  ),
  VocationalCluster(
    id: 3,
    name: "Ciencias de la salud",
    insight: "Interés marcado en el bienestar humano. Se sugiere plática con egresados de Medicina y Nutrición.",
    color: const Color(0xFFBA7517),
    students: [
      StudentPoint(id: "BC", name: "Beatriz Cano", x: 0.75, y: 0.75, clusterId: 3),
      StudentPoint(id: "CR", name: "César Ríos", x: 0.8, y: 0.8, clusterId: 3),
      StudentPoint(id: "DM", name: "Daniela Meza", x: 0.7, y: 0.7, clusterId: 3),
      StudentPoint(id: "ET", name: "Esteban Tello", x: 0.85, y: 0.85, clusterId: 3),
      StudentPoint(id: "FV", name: "Fernanda Vega", x: 0.68, y: 0.78, clusterId: 3),
      StudentPoint(id: "GP", name: "Gerardo Parra", x: 0.78, y: 0.68, clusterId: 3),
      StudentPoint(id: "HL", name: "Héctor Lara", x: 0.82, y: 0.72, clusterId: 3),
    ],
  ),
];

class VocationalMapScreen extends StatefulWidget {
  const VocationalMapScreen({super.key});

  @override
  State<VocationalMapScreen> createState() => _VocationalMapScreenState();
}

class _VocationalMapScreenState extends State<VocationalMapScreen> with SingleTickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();
  late AnimationController _animationController;
  
  StudentPoint? _selectedStudent;
  VocationalCluster? _selectedCluster;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    setState(() {});
  }

  void _handleTap(TapUpDetails details, Size canvasSize) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.globalPosition);
    final tapPos = _transformationController.toScene(localOffset);
    
    StudentPoint? tappedStudent;
    double minDistance = 22.0;

    for (var cluster in sampleClusters) {
      for (var student in cluster.students) {
        final double px = student.x * canvasSize.width;
        final double py = student.y * canvasSize.height;
        final double distance = sqrt(pow(px - tapPos.dx, 2) + pow(py - tapPos.dy, 2));
        
        if (distance < minDistance) {
          tappedStudent = student;
          minDistance = distance;
        }
      }
    }

    setState(() {
      if (tappedStudent != null) {
        _selectedStudent = tappedStudent;
        _selectedCluster = sampleClusters.firstWhere((c) => c.id == tappedStudent!.clusterId);
      } else {
        _selectedStudent = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(),
      body: Column(
        children: [
          _buildLegend(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
                return InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 0.4,
                  maxScale: 6.0,
                  boundaryMargin: const EdgeInsets.all(200),
                  child: GestureDetector(
                    onTapUp: (details) => _handleTap(details, canvasSize),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: canvasSize,
                          painter: VocationalMapPainter(
                            clusters: sampleClusters,
                            animationValue: _animationController.value,
                            selectedStudent: _selectedStudent,
                            selectedCluster: _selectedCluster,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInfoPanel(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mapa vocacional',
            style: TextStyle(color: const Color(0xFF1D1B4B), fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            '6° semestre A  ·  28 alumnos  ·  4 clusters',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.fit_screen_rounded, color: Color(0xFF311B92)),
          onPressed: _resetZoom,
        ),
      ],
      shape: Border(bottom: BorderSide(color: Colors.grey.shade100)),
    );
  }

  Widget _buildLegend() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: sampleClusters.length,
        itemBuilder: (context, index) {
          final cluster = sampleClusters[index];
          final isSelected = _selectedCluster?.id == cluster.id;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedCluster = null;
                } else {
                  _selectedCluster = cluster;
                }
                _selectedStudent = null;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: cluster.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${cluster.name} (${cluster.students.length})',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? cluster.color : Colors.grey.shade500,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoPanel() {
    final bool hasSelection = _selectedStudent != null || _selectedCluster != null;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      height: hasSelection ? 130.h : 0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [
          if (hasSelection)
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: _selectedStudent != null ? _buildStudentInfo() : _buildClusterInfo(),
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: _selectedCluster?.color ?? Colors.grey,
          child: Text(
            _selectedStudent!.id,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_selectedStudent!.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              Text(_selectedCluster?.name ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp)),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Text('Ver expediente', style: TextStyle(color: const Color(0xFF311B92), fontWeight: FontWeight.bold, fontSize: 13.sp)),
              const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF311B92)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClusterInfo() {
    if (_selectedCluster == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedCluster!.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: _selectedCluster!.color)),
            Text('${_selectedCluster!.students.length} alumnos', style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          _selectedCluster!.insight,
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700, height: 1.3),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// --- CUSTOM PAINTER ---

class VocationalMapPainter extends CustomPainter {
  final List<VocationalCluster> clusters;
  final double animationValue;
  final StudentPoint? selectedStudent;
  final VocationalCluster? selectedCluster;

  VocationalMapPainter({
    required this.clusters,
    required this.animationValue,
    this.selectedStudent,
    this.selectedCluster,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawAxes(canvas, size);
    _drawLabels(canvas, size);

    // Animación para el radio de los puntos
    final double elasticScale = Curves.elasticOut.transform(animationValue);

    // CAPA 1: BLOB DEL CLUSTER
    for (var cluster in clusters) {
      final centroid = cluster.getCentroid();
      final offset = Offset(centroid.dx * size.width, centroid.dy * size.height);
      
      double maxDist = 0;
      for (var s in cluster.students) {
        final dist = sqrt(pow(s.x - centroid.dx, 2) + pow(s.y - centroid.dy, 2));
        if (dist > maxDist) maxDist = dist;
      }

      final double radius = (maxDist * size.width + 52) * animationValue;
      
      // Dibujar Blob (Fill)
      final fillPaint = Paint()
        ..color = cluster.color.withOpacity(0.07)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(offset, radius, fillPaint);

      // Dibujar Borde Punteado
      final strokePaint = Paint()
        ..color = cluster.color.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      
      _drawDashedCircle(canvas, offset, radius, strokePaint);

      // CAPA 2: ETIQUETA DEL CLUSTER
      _drawClusterLabel(canvas, cluster, offset, cluster.color.withOpacity(0.6));
    }

    // CAPA 3: PUNTOS DE ALUMNO
    for (var cluster in clusters) {
      for (var student in cluster.students) {
        final double px = student.x * size.width;
        final double py = student.y * size.height;
        final bool isSelected = selectedStudent == student;
        final double dotRadius = (isSelected ? 20.0 : 15.0) * elasticScale;

        final pos = Offset(px, py);

        // Sombra
        final shadowPaint = Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
        canvas.drawCircle(pos.translate(0, 2), dotRadius, shadowPaint);

        // Selección highlight
        if (isSelected) {
          final ringPaint = Paint()
            ..color = cluster.color.withOpacity(0.2)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(pos, dotRadius + 6, ringPaint);
        }

        // Círculo principal
        final mainPaint = Paint()
          ..color = cluster.color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, dotRadius, mainPaint);

        // Borde blanco
        final borderPaint = Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(pos, dotRadius, borderPaint);

        // Iniciales
        final textPainter = TextPainter(
          text: TextSpan(
            text: student.id,
            style: TextStyle(
              color: Colors.white,
              fontSize: dotRadius * 0.6,
              fontWeight: FontWeight.w800,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, pos - Offset(textPainter.width / 2, textPainter.height / 2));
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..strokeWidth = 1.0;

    for (int i = 1; i < 6; i++) {
      double x = (size.width / 6) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      double y = (size.height / 6) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawAxes(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
  }

  void _drawLabels(Canvas canvas, Size size) {
    const textStyle = TextStyle(color: Color(0xFFCCCCCC), fontSize: 9, fontWeight: FontWeight.w400);
    
    void drawLabel(String text, Offset pos, Alignment align) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      
      Offset finalPos = pos;
      if (align == Alignment.topLeft) finalPos = pos;
      if (align == Alignment.topRight) finalPos = Offset(pos.dx - tp.width, pos.dy);
      if (align == Alignment.bottomLeft) finalPos = Offset(pos.dx, pos.dy - tp.height);
      if (align == Alignment.bottomRight) finalPos = Offset(pos.dx - tp.width, pos.dy - tp.height);

      tp.paint(canvas, finalPos);
    }

    drawLabel("ALTO ANÁLISIS", const Offset(10, 10), Alignment.topLeft);
    drawLabel("ALTA INTERACCIÓN SOCIAL", Offset(size.width - 10, 10), Alignment.topRight);
    drawLabel("BAJA INTERACCIÓN SOCIAL", Offset(10, size.height - 10), Alignment.bottomLeft);
    drawLabel("BAJO ANÁLISIS", Offset(size.width - 10, size.height - 10), Alignment.bottomRight);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    final double circumference = 2 * pi * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * (dashWidth + dashSpace) / circumference) * 2 * pi;
      final double endAngle = startAngle + (dashWidth / circumference) * 2 * pi;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, endAngle - startAngle, false, paint);
    }
  }

  void _drawClusterLabel(Canvas canvas, VocationalCluster cluster, Offset centroid, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: cluster.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    tp.paint(canvas, centroid - Offset(tp.width / 2, 70));
  }

  @override
  bool shouldRepaint(covariant VocationalMapPainter oldDelegate) => true;
}
