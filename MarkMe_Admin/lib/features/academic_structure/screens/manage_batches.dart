import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_state.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/widgets/batch_widgets/add_batch_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/batch_widgets/batch_container.dart';

import '../../../core/widgets/app_nav_bar.dart';

class ManageBatches extends StatefulWidget {
  const ManageBatches({super.key});

  @override
  State<ManageBatches> createState() => _ManageBatchesState();
}

class _ManageBatchesState extends State<ManageBatches> {
  List<Branch>? branches;

  @override
  void initState() {
    super.initState();
    context.read<AcademicBatchBloc>().add(LoadAllBranchesEvent());
  }

  @override
  Widget build(BuildContext context) {
    const List<IconData> _icons = [
      Icons.book,
      Icons.school,
      Icons.lightbulb,
      Icons.check_circle,
      Icons.schedule,
      Icons.people,
      Icons.laptop_mac,
      Icons.science,
      Icons.code,
    ];

    // Define a list of possible gradient color pairs
    const List<List<Color>> _gradientColorPairs = [
      [Color(0xFFA7E6FF), Color(0xFF66C2FF)], // Soft blue
      [Color(0xFFFFC9E0), Color(0xFFFF80B3)], // Soft pink
      [Color(0xFFFEE0B3), Color(0xFFFFB366)], // Soft orange
      [Color(0xFFB3FFB3), Color(0xFF66CC66)], // Soft green
      [Color(0xFFC9A7FF), Color(0xFF8066FF)], // Soft purple
      [Color(0xFFD1C4E9), Color(0xFF9575CD)], // Lavender
      [Color(0xFFB2EBF2), Color(0xFF4DD0E1)], // Cyan
      [Color(0xFFFFCCBC), Color(0xFFFF8A65)], // Peach
    ];

    final Random random = Random();

    IconData getRandomIcon() {
      return _icons[random.nextInt(_icons.length)];
    }

    List<Color> getRandomColorGradient() {
      return _gradientColorPairs[random.nextInt(_gradientColorPairs.length)];
    }

    return Scaffold(
      appBar: CustomAppNavBar(
        title: 'Manage Batches',
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              if(branches==null){
                return Center(child: CircularProgressIndicator(),);
              }
              return AddBatchBottomSheet(
                branches: branches!,
                onAddBatchClick: (batch) {
                  context.read<AcademicBatchBloc>().add(AddBatchEvent(batch));
                },
              );
            },
          );
        },
      ),
      body: BlocConsumer<AcademicBatchBloc, AcademicBatchState>(
        builder: (context, state) {
          if (state is AcademicBatchesLoaded) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: state.batches.length,
                itemBuilder: (context, index) {
                  AcademicBatch batch = state.batches[index];
                  return BatchContainer(
                    batchName: batch.batchId,
                    iconData: getRandomIcon(),
                    gradientColors: getRandomColorGradient(),
                    rightCornerButtonIcon: Icons.delete,
                    onRightCornerButtonPressed: () {
                      context.read<AcademicBatchBloc>().add(
                        DeleteBatchEvent(batch),
                      );
                    },
                  );
                },
              ),
            );
          }
          return Center(child: Text("No batches added yet"));
        },
        listener: (context, state) {
          if(state is AcademicBatchLoading){
            AppUtils.showCustomLoading(context);
          }else{
            Navigator.pop(context);
          }
          if(state is BranchesLoaded){
            setState(() {
              branches=state.branches;
            });
            context.read<AcademicBatchBloc>().add(LoadAllBatchesEvent());

          }else if(state is AcademicBatchError){
            AppUtils.showCustomSnackBar(context, state.message);
          }else if(state is AcademicBatchSuccess){
            AppUtils.showCustomSnackBar(context,"Successful");
          }

        },
      ),
    );
  }
}
