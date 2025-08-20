import zipfile
import tempfile
import os


serial_numbers = [
    "0005",
    "0006",
    "0007",
    "0008",
    "0009",
    "0010",
    "0011",
    "0012",
    "0013",
    "0014",
    # "0015",
    "0016",
    "0017",
    "0018",
    "0019",
    "0020",
    "0021",
    "0022",
    "0023",
    "0024",
    "0025",
    "0026",
    "0027",
]

filename_all = {
    "10mA": "Range10mA.txt",
    "1mA": "Range1mA.txt",
    "100uA": "Range100uA.txt",
    "10uA": "Range10uA.txt",
    "1uA": "Range1uA.txt",
    "100nA": "Range100nA.txt",
}


def create_pvs(I_range):
    prefix = r"${PREFIX}"
    gain_SP_pv = []
    gain_I_pv = []
    offset_SP_pv = []
    offset_I_pv = []
    for ch in ['A', 'B', 'C', 'D']:
        gain_SP_pv.append(prefix + f'Ch{ch}-{I_range}-Gain-SP')
        gain_I_pv.append(prefix + f'Ch{ch}-{I_range}-Gain-I')
        offset_SP_pv.append(prefix + f'Ch{ch}-{I_range}-Ofst-SP')
        offset_I_pv.append(prefix + f'Ch{ch}-{I_range}-Ofst-I')

    return gain_SP_pv, gain_I_pv, offset_SP_pv, offset_I_pv

def extract_values_from_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    gain = []
    offset = []

    for line in lines[1:5]:
        parts = line.strip().split(',')
        gain.append(int(parts[1]))
        offset.append(int(parts[2]))

    return gain, offset


if __name__ == '__main__':

    # fln_tmp = tempfile.mkstemp()[1]
    fln_tmp = tempfile.mktemp()
    os.makedirs(fln_tmp, exist_ok=True)
    print(f"Extracting calibration to temporary directory {fln_tmp!r}")

    for sn in serial_numbers:
        electrometer_serial = f"EC{sn}"
        fln = electrometer_serial
        fln_zip = f"{fln}.zip"
        fln_calib = f"{electrometer_serial}.cmd"
        print(f"Processing file {fln_zip!r}")
        with zipfile.ZipFile(fln_zip, "r") as z:
            z.extractall(fln_tmp)

        base_path = os.path.join(fln_tmp, fln)

        with open(fln_calib, "w") as f:
            s = f"# Calibration for NSLS2 Electrometer: serial number {electrometer_serial}"
            f.write(f"{'#' * len(s)}\n")
            f.write(f"{s}\n")
            f.write(f"{'#' * len(s)}\n")

            for I_range, filename in filename_all.items():
                gain, offset = extract_values_from_file(os.path.join(base_path, filename))
                gain_SP_pv, gain_I_pv, offset_SP_pv, offset_I_pv = create_pvs(I_range)
                # print(f'  I range: {I_range}\n  gain SP [A,B,C,D]: {gain}\n  offset SP [A,B,C,D]: {offset}')

                f.write(f"\n# Calibration for {I_range} range\n")
                for pv, gain in zip(gain_SP_pv, gain):
                    f.write(f"dbpf {pv} {-gain}\n")  # Negative gain is saved intentionally!
                for pv, offset in zip(offset_SP_pv, offset):
                    f.write(f"dbpf {pv} {offset}\n")
                # f.write(f"dbpf {gain_I_pv} 32000")
                # f.write(f"dbpf {offset_I_pv} 32000")
