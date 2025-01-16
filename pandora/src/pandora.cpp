#include <iostream>
#include <fstream>
#include <optional>
#include <vector>
#include <iomanip>
#include <cctype>

using namespace std;

optional<ifstream> readfile(const string& filename) {

    ifstream file(filename, ios::binary);

    if (!file.is_open()) {
        cerr << "Error: Unable to open file " << filename << endl;
        return nullopt;
    }
    // cout << "Reading file: " << filename << endl;
    return file;
}

void parse(ifstream& file, size_t bytesPerLine = 16) {

    vector<unsigned char> buffer(bytesPerLine);
    size_t offset = 0;

    while (file) {
        file.read(reinterpret_cast<char*>(buffer.data()), bytesPerLine);
        streamsize bytesRead = file.gcount();

        if (bytesRead == 0) break;

        // Print the offset
        cout << hex << setw(8) << setfill('0') << offset << "  ";

        // Print the hex values
        for (size_t i = 0; i < bytesPerLine; ++i) {
            if (i < static_cast<size_t>(bytesRead)) {
                cout << hex << setw(2) << static_cast<int>(buffer[i]) << " ";
            } else {
                cout << "   "; // Padding for unused bytes
            }
        }

        // Print ASCII representation
        cout << " ";
        for (size_t i = 0; i < static_cast<size_t>(bytesRead); ++i) {
            char c = static_cast<char>(buffer[i]);
            cout << (isprint(c) ? c : '.');
        }

        cout << endl;
        offset += bytesRead;
    }

    file.close();
}

void usage(char* argv) {
    cerr << "Usage: " << argv[0] << " <filename> [bytes_per_line]" << endl;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        usage(*argv);
        return 1;
    }

    string filename = argv[1];
    auto fileOpt = readfile(filename);
    if (fileOpt) {
        ifstream& f = *fileOpt;
        parse(f);
    }
    return 0;
}