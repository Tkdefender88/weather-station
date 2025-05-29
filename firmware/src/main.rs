#![no_std]
#![no_main]

use cortex_m_rt::entry;
use panic_halt as _;

use stm32f4xx_hal::{pac, prelude::*};

#[entry]
fn main() -> ! {
    let device_peripherals = pac::Peripherals::take().unwrap();
    let cortex_peripherals = cortex_m::Peripherals::take().unwrap();

    let rcc = device_peripherals.RCC.constrain();
    let clocks = rcc.cfgr.freeze();

    let mut delay = cortex_peripherals.SYST.delay(&clocks);

    let gpioc = device_peripherals.GPIOC.split();

    let mut led = gpioc.pc13.into_push_pull_output();
    loop {
        led.set_high();
        delay.delay_ms(1000u16);
    }
}
