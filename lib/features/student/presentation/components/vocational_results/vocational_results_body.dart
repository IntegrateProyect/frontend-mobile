import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/careers_provider.dart';
import '../../providers/student_results_provider.dart';
import '../../../../vocational_games/presentation/providers/games_provider.dart';
import '../../../../vocational_games/presentation/providers/game_persistence_provider.dart';
import '../common/student_ui_colors.dart';
import 'results_error_card.dart';
import 'vocational_results_empty_state.dart';
import 'riasec_overview_card.dart';
import 'recommended_careers_section.dart';
import 'incomplete_games_state.dart';

class VocationalResultsBody extends StatelessWidget {
  final StudentResultsProvider resultsProvider;
  final GamesProvider gamesProvider;
  final GamePersistenceProvider persistenceProvider;
  final CareersProvider careersProvider;
  final RefreshCallback onRefresh;
  final VoidCallback onGoToGames;

  const VocationalResultsBody({
    super.key,
    required this.resultsProvider,
    required this.gamesProvider,
    required this.persistenceProvider,
    required this.careersProvider,
    required this.onRefresh,
    required this.onGoToGames,
  });

  @override
  Widget build(BuildContext context) {
    if ((gamesProvider.isLoading && gamesProvider.miniGames.isEmpty) ||
        (resultsProvider.isLoading && resultsProvider.results.isEmpty)) {
      return const Center(
        child: CircularProgressIndicator(
          color: StudentUiColors.primary,
        ),
      );
    }

    if (!persistenceProvider.areAllCompleted(gamesProvider.miniGames) &&
        resultsProvider.results.isEmpty) {
      return IncompleteGamesState(onContinue: onGoToGames);
    }

    return RefreshIndicator(
      color: StudentUiColors.primary,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          18.w,
          16.h,
          18.w,
          30.h,
        ),
        children: [
          if (resultsProvider.errorMessage != null) ...[
            ResultsErrorCard(
              message: resultsProvider.errorMessage!,
              onRetry: onRefresh,
            ),
            SizedBox(height: 16.h),
          ],
          if (resultsProvider.results.isEmpty)
            const VocationalResultsEmptyState()
          else ...[
            RiasecOverviewCard(result: resultsProvider.results.first),
            SizedBox(height: 24.h),
            RecommendedCareersSection(
              provider: careersProvider,
            ),
          ],
        ],
      ),
    );
  }
}
