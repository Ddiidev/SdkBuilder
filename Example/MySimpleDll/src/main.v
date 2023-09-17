module main

[export: 'return_integer32']
fn return_integer32() int {
	return 32
}

[export: 'return_float32']
fn return_float32() f32 {
	return 32.0
}

[export: 'return_string']
fn return_string() string {
	return '32 - teste'
}

pub struct Struct {
pub mut:
	i int
	s string
}

[export: 'return_struct']
fn return_struct() Struct {
	return Struct{
		i: 32
		s: "Hello Word!"
	}
}

[export: 'return_void']
fn return_void() {
	println("is void")
}

[export: 'input_args']
fn input_args(s string, i int) int {
	return s.int() + i
}

[export: 'fibonacci']
fn fibonacci(n f64) f64 {
    mut f_n := n
    mut f_n1 := f64(0.0)
    mut f_n2 := f64(1.0)

    if n / 1 > 0 {
		for i := 1; i < n; i++ {
			f_n = f_n1 + f_n2
			f_n1 = f_n2
			f_n2 = f_n
		}
	}

	return f_n
}