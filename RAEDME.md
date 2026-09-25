# Pseudo Multi-Port RAM Wrapper

A **Pseudo Multi-Port RAM Wrapper** (also known as a **Time-Multiplexed** or **Double-Pumped** RAM Wrapper) is an architectural hardware design technique used in Digital System Design and FPGA/ASIC synthesis.

It allows a standard physical **Single-Port RAM** to emulate the functionality of a **True Dual-Port RAM** without doubling the required silicon area.

---

## 📌 Overview & Core Motivation

Standard Single-Port Memory blocks have a fundamental hardware constraint:
* **Single-Port RAM Restriction:** Contains only one shared set of address, data, and control lines. It can execute **only one operation** (either a single Read OR a single Write) per clock cycle.

Instead of instantiating larger, area-expensive True Dual-Port memory cells, the **Pseudo Multi-Port Wrapper** bypasses this physical limitation by time-sharing (multiplexing) the underlying memory array within a single system clock cycle.

---

## ⏱️ How It Works (Time Multiplexing)

The wrapper uses both clock phases (or an internally doubled clock frequency) to perform two distinct accesses within one main clock period:

* **Phase 1 (e.g., Clock High / Rising Edge):** Execute the **Read** operation.
* **Phase 2 (e.g., Clock Low / Falling Edge):** Execute the **Write** operation.

```text
               System Clock Cycle (T)
      +-------------------+-------------------+
CLK:  |     HIGH / R1     |     LOW / W2      |
      +-------------------+-------------------+
      |                   |                   |
      v                   v                   v
 Operation 1:        Operation 2:        Data Latched
 Read Request        Write Request       to Output
```

## 🏗️ Architecture & Block Diagram

The Pseudo Dual-Port Wrapper encapsulates the single-port RAM macro and exposes two separate interfaces to the system. An internal multiplexing unit controls which port drives the underlying memory lines based on the clock phase or time slot.

```text
                  +-----------------------------------+
                  |      Pseudo Dual-Port Wrapper     |
  System Clock --->                                   |
                  |   +-------+                       |
  Port A (Read)  ---> |       |                       |
                  |   | MUXes | ---> Single-Port RAM  |
  Port B (Write) ---> |       |      (Address/Data)   |
                  |   +-------+                       |
                  +-----------------------------------+
```
## Output 
### Simulation Terminal
<img width="826" height="180" alt="image" src="https://github.com/user-attachments/assets/2efae86e-7751-433f-9f1f-c08d6c6a8ac5" />


### Waveform
<img width="959" height="245" alt="image" src="https://github.com/user-attachments/assets/24cdc7b1-fbdb-4c36-8c22-8257a124d136" />

