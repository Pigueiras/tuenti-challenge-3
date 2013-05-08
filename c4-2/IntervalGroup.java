import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.EOFException;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class IntervalGroup {

	private static long HALF_MAX_NUMBER = 1073741824;
	private static String FILE_NAME = "C:\\integers";

	public static void main(String args[]) throws IOException {
		boolean[] group1 = new boolean[(int) HALF_MAX_NUMBER];
		boolean[] group2 = new boolean[(int) HALF_MAX_NUMBER];
		double counter = 1.0;

		DataInputStream data = new DataInputStream(new BufferedInputStream(
				new FileInputStream(new File(FILE_NAME))));

		byte[] b = new byte[4];
		try {
			while (true) {
				data.read(b);
				int number = byteArrayToInt(b);
				if (number - ((int) HALF_MAX_NUMBER) < 0)
					group1[number] = true;
				else
					group2[number - ((int) HALF_MAX_NUMBER)] = true;
				if (counter % 1000000 == 0)
					System.out.println("Status:" + (counter /((long) HALF_MAX_NUMBER * 2)) * 100
							+ "%");
				counter++;
				if (counter > ((long) HALF_MAX_NUMBER * 2))
					break;
			}
		} catch (EOFException e) {
			// we expect it so ignore
		}

		for (int i = 0; i < group1.length; i++) {
			if (!group1[i])
				System.out.println(i);
		}

		for (int i = 0; i < group2.length; i++) {
			if (!group2[i])
				System.out.println(i + ((int) HALF_MAX_NUMBER));
		}

	}

	public static int byteArrayToInt(byte[] b) {
		final ByteBuffer bb = ByteBuffer.wrap(b);
		bb.order(ByteOrder.LITTLE_ENDIAN);
		return bb.getInt();
	}

}
