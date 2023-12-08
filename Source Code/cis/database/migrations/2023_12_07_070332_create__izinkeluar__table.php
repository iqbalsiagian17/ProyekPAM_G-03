<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateIzinKeluarTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()

    {
        Schema::create('Izinkeluar', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id'); // Menyimpan ID Mahasiswa atau BAAK
            $table->text('reason'); // Alasan izin keluar
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending'); // Status izin (pending, approved, rejected)
            $table->timestamp('time_out')->nullable(); // Waktu keluar
            $table->timestamp('time_in')->nullable(); // Waktu kembali
            $table->timestamps();

            // Relasi dengan tabel User (Mahasiswa atau BAAK)
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Izinkeluar');
    }
};
