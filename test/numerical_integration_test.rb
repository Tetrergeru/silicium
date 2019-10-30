require 'test_helper'
require 'numerical_integration'

class NumericalIntegrationTest < Minitest::Test
  include Silicium
  @@delta = 0.0001

  def test_log_three_eights_integration
    assert_in_delta Math.log(3.5),
                    NumericalIntegration.three_eights_integration(2, 7) { |x| 1 / x }, @@delta
  end

  def test_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(0, 7) { |x| 1 / x }
    end
  end

  def test_nan_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(0, 1) { |x| 1 / Math.log(x) }
    end
  end

  def test_domain_sqrt_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(-8, 7) { |x| Math.sqrt(x) }
    end
  end

  def test_domain_log_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(-8, 7) { |x| Math.log(x) }
    end
  end

  def test_domain_asin_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(-6, 16) { |x| Math.asin(x + 6) }
    end
  end

  def test_domain_sqrt2_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(-1, 7) { |x| 1 / Math.sqrt(x) + 23 }
    end
  end

  def test_domain_log_difference_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(0, 2) { |x| Math.log(x) - Math.log(x) }
    end
  end

  def test_domain_log_quotient_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(0, 3) { |x| Math.log(x) / Math.log(x) }
    end
  end

  def test_sin_three_eights_integration
    assert_in_delta Math.sin(8) + Math.sin(10),
                    NumericalIntegration.three_eights_integration(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_three_eights_integration
    assert_in_delta Math.atan(Math::PI),
                    NumericalIntegration.three_eights_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_three_eights_integration
    assert_in_delta Math::PI / 6,
                    NumericalIntegration.three_eights_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_three_eights_integration
    assert_in_delta 442.818,
                    NumericalIntegration.three_eights_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_something_scary_accuracy_001_three_eights_integration
    assert_in_delta 442.82,
                    NumericalIntegration.three_eights_integration(2, 5, 0.01) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.01
  end

  def test_something_scary_accuracy_01_three_eights_integration
    assert_in_delta 442.8,
                    NumericalIntegration.three_eights_integration(2, 5, 0.1) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.1
  end

  def test_reverse_three_eights_integration
    assert_in_delta (-(Math.sin(3) + Math.sin(4))),
                    NumericalIntegration.three_eights_integration(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_three_eights_integration
    assert_in_delta 0,
                    NumericalIntegration.three_eights_integration(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.three_eights_integration(-10, 18) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_polynom_accuracy_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.three_eights_integration(-10, 18, 0.00001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end

  def test_polynom_accuracy_0_0001_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.three_eights_integration(-10, 18, 0.0001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.0001
  end

  def test_polynom_accuracy_0_001_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.three_eights_integration(-10, 18, 0.001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.001
  end

  def test_log_simpson_integration
    assert_in_delta Math.log(3.5),
                    NumericalIntegration.simpson_integration(2, 7) { |x| 1 / x }, @@delta
  end

  def test_sin_simpson_integration
    assert_in_delta Math.sin(8) + Math.sin(10),
                    NumericalIntegration.simpson_integration(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_simpson_integration
    assert_in_delta Math.atan(Math::PI),
                    NumericalIntegration.simpson_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_simpson_integration
    assert_in_delta Math::PI / 6,
                    NumericalIntegration.simpson_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_simpson_integration
    assert_in_delta 442.818,
                    NumericalIntegration.simpson_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_reverse_simpson_integration
    assert_in_delta (-(Math.sin(3) + Math.sin(4))),
                    NumericalIntegration.simpson_integration(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_simpson_integration
    assert_in_delta 0,
                    NumericalIntegration.simpson_integration(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_simpson_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.simpson_integration(-10, 18) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_error_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(0, 7) { |x| 1 / x }
    end
  end

  def test_nan_error_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(0, 1) { |x| 1 / Math.log(x) }
    end
  end

  def test_domain_error1_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(-8, 7) { |x| Math.sqrt(x) }
    end
  end

  def test_domain_error2_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(-8, 7) { |x| Math.log(x) }
    end
  end

  def test_domain_error3_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(-6, 16) { |x| Math.asin(x + 6) }
    end
  end

  def test_domain_error_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(-1, 7) { |x| 1 / Math.sqrt(x) + 23 }
    end
  end

#
  def test_log_left_rect_integration
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.left_rect_integration(2, 7) { |x| 1 / x }, @@delta
  end

  def test_sin_left_rect_integration
    assert_in_delta Math.sin(8) + Math.sin(10),
                    ::Silicium::NumericalIntegration.left_rect_integration(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_left_rect_integration
    assert_in_delta Math.atan(Math::PI),
                    ::Silicium::NumericalIntegration.left_rect_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_left_rect_integration
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration.left_rect_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_left_rect_integration
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration.left_rect_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_reverse_left_rect_integration
    assert_in_delta (-(Math.sin(3) + Math.sin(4))),
                    ::Silicium::NumericalIntegration.left_rect_integration(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_left_rect_integration
    assert_in_delta 0,
                    ::Silicium::NumericalIntegration.left_rect_integration(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_left_rect_integration
    assert_in_delta (-159.75),
                    ::Silicium::NumericalIntegration.left_rect_integration(-0.5, 0.5) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_polynom_accuracy_left_rect_integration
    assert_in_delta (-159.75),
                    ::Silicium::NumericalIntegration.left_rect_integration(-0.5, 0.5, 0.00001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end

  def test_log_middle_rectangles
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.middle_rectangles(2, 7) { |x| 1 / x }, @@delta
  end

  def test_sin_middle_rectangles
    assert_in_delta Math.sin(8) + Math.sin(10),
                    ::Silicium::NumericalIntegration.middle_rectangles(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_middle_rectangles
    assert_in_delta Math.atan(Math::PI),
                    ::Silicium::NumericalIntegration.middle_rectangles(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_middle_rectangles
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration.middle_rectangles(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_middle_rectangles
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration.middle_rectangles(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_something_scary_accuracy_001_middle_rectangles
    assert_in_delta 442.82,
                    ::Silicium::NumericalIntegration.middle_rectangles(2, 5, 0.01) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.01
  end

  def test_something_scary_accuracy_01_middle_rectangles
    assert_in_delta 442.8,
                    ::Silicium::NumericalIntegration.middle_rectangles(2, 5, 0.1) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.1
  end

  def test_reverse_middle_rectangles
    assert_in_delta (-1 * (Math.sin(3) + Math.sin(4))),
                    ::Silicium::NumericalIntegration.middle_rectangles(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_middle_rectangles
    assert_in_delta 0,
                    ::Silicium::NumericalIntegration.middle_rectangles(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_middle_rectangles
    assert_in_delta (-0.32),
                    ::Silicium::NumericalIntegration.middle_rectangles(-0.001, 0.001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_polynom_accuracy_middle_rectangles
    assert_in_delta (-0.32),
                    ::Silicium::NumericalIntegration.middle_rectangles(-0.001, 0.001, 0.00001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end

  def test_log_trapezoid
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.trapezoid(2, 7) { |x| 1 / x }, @@delta
  end

  def test_sin_trapezoid
    assert_in_delta Math.sin(8) + Math.sin(10),
                    ::Silicium::NumericalIntegration.trapezoid(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_trapezoid
    assert_in_delta Math.atan(Math::PI),
                    ::Silicium::NumericalIntegration.trapezoid(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_trapezoid
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration.trapezoid(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end


  def test_something_scary_trapezoid
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration.trapezoid(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_something_scary_accuracy_001_trapezoid
    assert_in_delta 442.82,
                    ::Silicium::NumericalIntegration.trapezoid(2, 5, 0.01) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.01
  end

  def test_something_scary_accuracy_01_trapezoid
    assert_in_delta 442.8,
                    ::Silicium::NumericalIntegration.trapezoid(2, 5, 0.1) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.1
  end

  def test_reverse_trapezoid
    assert_in_delta (-1 * (Math.sin(3) + Math.sin(4))),
                    ::Silicium::NumericalIntegration.trapezoid(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_trapezoid
    assert_in_delta 0,
                    ::Silicium::NumericalIntegration.trapezoid(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_trapezoid
    assert_in_delta (-0.32),
                    ::Silicium::NumericalIntegration.trapezoid(-0.001, 0.001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_polynom_accuracy_trapezoid
    assert_in_delta (-0.32),
                    ::Silicium::NumericalIntegration.trapezoid(-0.001, 0.001, 0.00001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end

end