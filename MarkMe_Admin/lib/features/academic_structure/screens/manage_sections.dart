import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_state.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/widgets/section_widgets/add_section_bottom_sheet.dart';

import '../bloc/section_bloc/section_event.dart';
import '../../../core/widgets/app_nav_bar.dart';
import '../widgets/section_widgets/section_card.dart';

class ManageSections extends StatefulWidget {
  const ManageSections({super.key});

  @override
  State<ManageSections> createState() => _ManageSectionsState();
}

class _ManageSectionsState extends State<ManageSections> {
  List<AcademicBatch>? batches;
  List<Branch>? branches;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SectionBloc>().add(LoadAllBranchesEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial data load when the screen is built

    return Scaffold(
      appBar: CustomAppNavBar(
        title: 'Manage Sections',
          onTap: () {
            if (batches == null || branches == null) {
              AppUtils.showCustomSnackBar(context, "Please wait, still loading data...");
              return;
            }
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) {
                return AddSectionBottomSheet(
                  batches: batches!,
                  branches: branches!,
                  onAddSectionClick: (section) {
                    context.read<SectionBloc>().add(AddNewSectionEvent(section));
                  },
                );
              },
            );
          },
      ),
      body: BlocConsumer<SectionBloc, SectionState>(
          listener: (context, state) {
            if (state is SectionLoading) {
              AppUtils.showCustomLoading(context);
            } else {
              if (Navigator.canPop(context)) Navigator.pop(context); // safer pop
            }

            if (state is SectionError) {
              AppUtils.showCustomSnackBar(context, state.message);
            } else if (state is SectionSuccess) {
              AppUtils.showCustomSnackBar(context, "Operation successful");
            }

            if (state is BranchesLoaded) {
              setState(() {
                branches = state.branches;
              });
              context.read<SectionBloc>().add(LoadAllBatchesEvent());
            } else if (state is BatchesLoaded) {
              setState(() {
                batches = state.batches;
              });
              context.read<SectionBloc>().add(LoadAllSectionEvent());
            }
          },
        builder: (context, state) {
          if (state is SectionsLoaded) {
            final sections = state.sections;

            if (sections.isEmpty) {
              return const Center(child: Text("No sections found."));
            }

            return ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return SectionCard(
                  section: section,
                  onDelete: () {
                    context.read<SectionBloc>().add(
                      DeleteSectionEvent(section),
                    );
                  },
                );
              },
            );
          } else if (state is SectionError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("Initializing..."));
        },
      ),
    );
  }
}
