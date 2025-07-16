@echo off
echo Starting Black Box Tests for HewanKu AR Flutter Application
echo ============================================================

echo.
echo Setting up test environment...
call flutter clean
call flutter pub get

echo.
echo Running black box tests...
echo.

echo [1/7] Running helper tests...
call flutter test test/black_box_tests/helpers/

echo [2/7] Running home page tests...
call flutter test test/black_box_tests/pages/home/

echo [3/7] Running animals page tests...
call flutter test test/black_box_tests/pages/animals/

echo [4/7] Running quiz tests...
call flutter test test/black_box_tests/pages/quiz/

echo [5/7] Running camera tests...
call flutter test test/black_box_tests/pages/camera/

echo [6/7] Running score tracking tests...
call flutter test test/black_box_tests/pages/score_tracking/

echo [7/7] Running integration tests...
call flutter test test/black_box_tests/integration/

echo.
echo Running all black box tests together...
call flutter test test/black_box_tests/all_black_box_tests.dart

echo.
echo Generating test coverage report...
call flutter test --coverage test/black_box_tests/

echo.
echo ============================================================
echo Black Box Testing Complete!
echo Check the coverage/lcov.info file for detailed coverage data.
echo ============================================================

pause
